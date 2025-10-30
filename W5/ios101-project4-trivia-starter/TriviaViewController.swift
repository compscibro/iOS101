import UIKit

// Question model used by the UI
struct Question {
    let text: String
    let choices: [String]    // 2 for True/False, 4 for multiple choice
    let correctIndex: Int    // 0...(choices.count-1)
}

// MARK: - OpenTDB DTOs
private struct OpenTDBResponse: Decodable {
    let response_code: Int
    let results: [OpenTDBItem]
}

private struct OpenTDBItem: Decodable {
    let type: String    // "multiple" or "boolean"
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

final class TriviaViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!    // ONE outlet collection with all 4 buttons

    // MARK: - Data
    private var questions: [Question] = []    // populated from network
    private var current = 0
    private var score = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start by fetching a fresh set
        fetchQuestions()
    }

    // MARK: - UI State
    private func setLoadingUI(_ isLoading: Bool) {
        headerLabel.text = isLoading ? "Loading…" : headerLabel.text
        questionLabel.text = isLoading ? "Loeading new questions." : questionLabel.text
        for btn in choiceButtons {
            btn.isEnabled = !isLoading
            btn.alpha = isLoading ? 0.5 : 1.0
            if isLoading { btn.setTitle("—", for: .normal) }
        }
    }

    private func showQuestion() {
        guard current < questions.count else {
            finishGame()
            return
        }

        let q = questions[current]
        headerLabel.text = "Question: \(current + 1)/\(questions.count)"
        questionLabel.text = q.text

        // Configure buttons for the question, T/F uses 2, multiple uses 4
        for (i, btn) in choiceButtons.enumerated() {
            if i < q.choices.count {
                btn.setTitle(q.choices[i], for: .normal)
                btn.isEnabled = true
                btn.alpha = 1.0
                btn.tag = i
                btn.isHidden = false
            } else {
                // Hide any unused buttons, show only 2 for True/False
                btn.setTitle("—", for: .normal)
                btn.isEnabled = false
                btn.alpha = 0.5
                btn.tag = -1
                btn.isHidden = true
            }
        }
    }

    private func finishGame() {
        let alert = UIAlertController(
            title: "Trivia is over!",
            message: "Your score is \(score)/\(questions.count).",
            preferredStyle: .alert
        )
        // Replay the same set
        alert.addAction(UIAlertAction(title: "Re-play", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.current = 0
            self.score = 0
            self.showQuestion()
        }))
        // Fetch a different set when user resets
        alert.addAction(UIAlertAction(title: "New", style: .default, handler: { [weak self] _ in
            self?.fetchQuestions()
        }))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @IBAction func choiceTapped(_ sender: UIButton) {
        let tappedIndex = sender.tag
        guard current < questions.count,
              tappedIndex >= 0, tappedIndex < questions[current].choices.count else { return }

        if tappedIndex == questions[current].correctIndex {
            score += 1
        }

        current += 1
        if current < questions.count {
            showQuestion()
        } else {
            finishGame()
        }
    }

    // MARK: - Networking
    private func fetchQuestions() {
        setLoadingUI(true)
        current = 0
        score = 0

        // Mix of multiple + boolean, category 18 (Computers), difficulty hard, request 10 (we'll use at least 5)
        let urlStr = "https://opentdb.com/api.php?amount=10&category=18&difficulty=hard"
        guard let url = URL(string: urlStr) else {
            self.failoverToLocal("Bad URL.")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, resp, err in
            guard let self else { return }
            if let err = err {
                DispatchQueue.main.async { self.failoverToLocal("Network error: \(err.localizedDescription)") }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { self.failoverToLocal("Empty response.") }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(OpenTDBResponse.self, from: data)
                guard decoded.response_code == 0 else {
                    DispatchQueue.main.async { self.failoverToLocal("API responded with code \(decoded.response_code).") }
                    return
                }

                // Map API items → our Question model
                let mapped: [Question] = decoded.results.compactMap { item in
                    let qText = item.question.htmlDecoded
                    let correct = item.correct_answer.htmlDecoded
                    let incorrect = item.incorrect_answers.map { $0.htmlDecoded }

                    if item.type == "boolean" {
                        // Only two options: True/False (Req 2)
                        // OpenTDB uses "True"/"False" capitalization; keep it consistent and shuffle
                        var choices = ["True", "False"]
                        choices.shuffle()
                        guard let correctIdx = choices.firstIndex(of: correct) else { return nil }
                        return Question(text: qText, choices: choices, correctIndex: correctIdx)
                    } else {
                        // Multiple choice: 4 options
                        var choices = incorrect + [correct]
                        choices.shuffle()
                        guard let correctIdx = choices.firstIndex(of: correct) else { return nil }
                        return Question(text: qText, choices: choices, correctIndex: correctIdx)
                    }
                }

                // Ensure at least 5 questions
                let final = Array(mapped.prefix(max(5, min(mapped.count, 10))))

                DispatchQueue.main.async {
                    if final.count < 5 {
                        self.failoverToLocal("Received fewer than 5 questions.")
                        return
                    }
                    self.questions = final
                    self.setLoadingUI(false)
                    self.showQuestion()
                }
            } catch {
                DispatchQueue.main.async { self.failoverToLocal("Parse error: \(error.localizedDescription)") }
            }
        }
        task.resume()
    }

    // If fetching fails, fall back to a small local set so the app still works
    private func failoverToLocal(_ reason: String) {
        print("Falling back to local questions. Reason: \(reason)")
        self.questions = [
            Question(text: "What is the object-oriented way to get rich?",
                     choices: ["Abstraction", "Encapsulation", "Polymorphism", "Inheritance"],
                     correctIndex: 3),
            Question(text: "You're debugging your romantic life like a C program. What's the logical error?",
                     choices: ["Forgot semicolon after: I love you", "Infinite loop in while(single)", "Uninitialized Variable: HerFeelings", "Seg Fault: Core Heart Dumped"],
                     correctIndex: 1),
            Question(text: "You can deadlift 250 lbs, but what's the one thing heavier than that?",
                     choices: ["Grinding LeetCode", "Going outside and touch grass", "Unresolved merge conflicts", "Talking to a girl"],
                     correctIndex: 3),
            Question(text: "Who's the current CEO of Apple?",
                     choices: ["Steve Jobs", "Tim Cook", "Steve Wozniak", "Craig Federighi"],
                     correctIndex: 1),
            Question(text: "What's not a programming language?",
                     choices: ["Swift", "Java", "C", "HTML"],
                     correctIndex: 0),
        ]
        self.current = 0
        self.score = 0
        self.setLoadingUI(false)
        self.showQuestion()
    }
}

// MARK: HTML  decoding
private extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        // If decoding fails, just return the original
        let decoded = (try? NSAttributedString(data: data, options: options, documentAttributes: nil))?.string
        return decoded ?? self
    }
}
