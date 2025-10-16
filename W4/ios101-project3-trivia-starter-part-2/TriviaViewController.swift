import UIKit

//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Mohammed Abdur Rahman on 10/11/25.
//

struct Question
{
    let text: String
    let choices: [String]
    let correctIndex: Int
}

final class TriviaViewController: UIViewController
{

    // These are linked from storyboard: UI Labels and UI Buttons
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!

    // These are the questions, options, and the correct answer's index
    private let questions: [Question] = [
        Question(text: "What is the object-oriented way to get rich?",
                 choices: ["Abstraction", "Encapsulation", "Polymorphism", "Inheritance"], correctIndex: 3),
        Question(text: "You're debugging your romantic life like a C program. What's the logical error?", choices: ["Forgot semicolon after: I love you", "Infinite loop in while(single)", "Uninitialized Variable: HerFeelings", "Seg Fault: Core Heart Dumped"], correctIndex: 1),
        Question(text: "You can deadlift 250 lbs, but what's the one thing heavier than that?",
                 choices: ["Your pom.xml", "The sadness after a pipeline failure", "Your unresolved merge conflicts", "Approaching to a girl"], correctIndex: 2)
    ]
    
    // Track current question
    private var current = 0
    // Track score
    private var score = 0

    // Show the first question upon loading
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
    }

    // Update  the question and button titles based on current: total 3 questions
    private func showQuestion()
    {
        guard current < questions.count else {
            print("showQuestion(): current (\(current)) out of range -> finishGame()")
            finishGame()
            return
        }

        let q = questions[current]
        headerLabel.text = "Question: \(current + 1)/\(questions.count)"
        questionLabel.text = q.text

        let connectedButtons = choiceButtons ?? []
        let count = min(connectedButtons.count, q.choices.count, 4)

        for i in 0..<count {
            let btn = connectedButtons[i]
            btn.setTitle(q.choices[i], for: .normal)
            btn.isEnabled = true
            btn.alpha = 1.0
        }
        
        if connectedButtons.count > count {
            for i in count..<connectedButtons.count {
                let btn = connectedButtons[i]
                btn.setTitle("—", for: .normal)
                btn.isEnabled = false
                btn.alpha = 0.5
            }
        }
    }

    // Pop alert with the score
    private func finishGame()
    {
        let alert = UIAlertController(
            title: "Trivia is over!",
            message: "Your score is \(score)/\(questions.count).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            guard let self else { return }
            self.current = 0
            self.score = 0
            self.showQuestion()
        })
        present(alert, animated: true)
    }
    
    // Run everytime a button is tapped
    @IBAction func choiceTapped(_ sender: UIButton)
    {
        print("Tapped:", sender.currentTitle ?? "no title")
        print("Before: current = \(current), score = \(score)")

        guard let buttons = choiceButtons,
              let tappedIndex = buttons.firstIndex(of: sender) else {
            return
        }

        if tappedIndex == questions[current].correctIndex {
            score += 1
        }

        sender.isEnabled = false
        sender.alpha = 0.6

        current += 1
        print("After: current = \(current), score = \(score)")

        if current < questions.count {
            showQuestion()
        } else {
            finishGame()
        }
    }
}
