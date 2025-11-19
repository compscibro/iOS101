import UIKit

// MARK: - API Models
struct StoicQuoteResponse: Codable {
    let data: StoicQuote
}

struct StoicQuote: Codable {
    let author: String
    let quote: String
}

let fallbackQuotes: [(quote: String, author: String)] = [
    ("Waste no more time arguing about what a good man should be. Be one.", "Marcus Aurelius"),
    ("We suffer more often in imagination than in reality.", "Seneca"),
    ("He who fears death will never do anything worthy of a living man.", "Seneca"),
    ("Man conquers the world by conquering himself.", "Zeno of Citium"),
    ("The obstacle is the way.", "Marcus Aurelius"),
    ("We become what we repeatedly do.", "Aristotle"),
    ("The happiness of your life depends upon the quality of your thoughts.", "Marcus Aurelius")
]

// MARK: - View Controller
class QuotesViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchStoicQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStoicQuote()   // refresh quote every time you come back
    }


    func setupUI() {
        quoteLabel.text = ""       // no placeholder text
        quoteLabel.alpha = 0       // hidden until first quote loads
        
        quoteLabel.textAlignment = .center
        quoteLabel.numberOfLines = 0
        quoteLabel.adjustsFontSizeToFitWidth = false   // <- handled by multiline layout instead
        quoteLabel.lineBreakMode = .byWordWrapping
        
        quoteLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(quoteTapped))
        quoteLabel.addGestureRecognizer(tap)
    }

    func fetchStoicQuote() {
        let url = URL(string: "https://stoic.tekloon.net/stoic-quote")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let data = data,
                let decoded = try? JSONDecoder().decode(StoicQuoteResponse.self, from: data)
            else {
                DispatchQueue.main.async {
                    self.loadFallbackQuote()
                }
                return
            }

            DispatchQueue.main.async {
                self.applyStyledQuote(
                    quote: decoded.data.quote,
                    author: decoded.data.author
                )
            }
        }.resume()
    }
    
    // MARK: - Fallback Loader
    func loadFallbackQuote() {
        let random = fallbackQuotes.randomElement()!
        applyStyledQuote(quote: random.quote, author: random.author)
    }

    // MARK: - Styling + Animation
    func applyStyledQuote(quote: String, author: String) {

        // Clean unwanted characters
        let cleanedQuote = quote
            .replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let cleanedAuthor = author
            .replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Build full display text
        let fullString = "\"\(cleanedQuote)\"\n\n— \(cleanedAuthor)"

        let attributed = NSMutableAttributedString(string: fullString)

        // MARK: Quote Styling
        let quoteRange = (fullString as NSString).range(of: "\"\(cleanedQuote)\"")
        attributed.addAttributes([
            .font: UIFont(name: "Times New Roman Bold", size: 28) ?? UIFont.boldSystemFont(ofSize: 28),
            .foregroundColor: UIColor.label
        ], range: quoteRange)

        // MARK: Author Styling
        let authorRange = (fullString as NSString).range(of: "— \(cleanedAuthor)")
        attributed.addAttributes([
            .font: UIFont.italicSystemFont(ofSize: 20),
            .foregroundColor: UIColor.secondaryLabel
        ], range: authorRange)

        // MARK: Paragraph Styling
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = 8
        style.paragraphSpacing = 12

        attributed.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributed.length))

        // MARK: Fade-In Animation
        quoteLabel.alpha = 0        // hide first
        quoteLabel.attributedText = attributed

        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
            self.quoteLabel.alpha = 1
        }
    }
    
    @objc func quoteTapped() {
        // Haptic
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Tap animation
        UIView.animate(withDuration: 0.1,
                       animations: { self.quoteLabel.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.quoteLabel.transform = .identity
            }
        }

        // Refresh quote
        fetchStoicQuote()
    }

}
