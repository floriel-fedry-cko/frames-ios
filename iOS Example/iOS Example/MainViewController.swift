import UIKit
import PassKit
import CheckoutSdkIos

class MainViewController: UIViewController {

    let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardsUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    @IBOutlet weak var schemeIconsView: UIStackView!
    @IBOutlet weak var cardNumberInputView: CardNumberInputView!
    @IBOutlet weak var expirationDateInputView: ExpirationDateInputView!
    @IBOutlet weak var cvvInputView: StandardInputView!

//    @IBAction func onTouchPayButton(_ sender: Any) {
//        let cardNumber = cardsUtils.standardize(cardNumber: cardNumberField.text!)
//        let (expiryMonth, expiryYear) = cardsUtils.standardize(expirationDate: expirationDateField.text!)
//        let cvv = cvvField.text!
//        let cardTypeOpt = cardsUtils.getTypeOf(cardNumber: cardNumber)
//        guard let cardType = cardTypeOpt else { return }
//        if !cardsUtils.isValid(cvv: cvv, cardType: cardType) {
//            return
//        }
//        let card = CardRequest(number: cardNumber, expiryMonth: expiryMonth,
//                               expiryYear: expiryYear, cvv: cvv, name: nil)
//        checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
//            let alert = UIAlertController(title: "Payment successful",
//                                          message: "Your card token: \(cardToken.id)", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//        }, errorHandler: { error in
//            let alert = UIAlertController(title: "Payment unsuccessful",
//                                          message: "Error: \(error)", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//        })
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let textFields = [cardNumberInputView.textField!, expirationDateInputView.textField!, cvvInputView.textField!]
        addKeyboardToolbarNavigation(textFields: textFields)

        checkoutAPIClient.getCardProviders(successHandler: { data in
            for provider in data {
                let schemeOpt = CardScheme(rawValue: provider.name.lowercased())
                if let scheme = schemeOpt { self.addSchemeIcon(scheme: scheme) }
            }
            self.addFillerView()
        }, errorHandler: { error in
            print(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func addSchemeIcon(scheme: CardScheme) {
        guard let schemeIconsViewUnwrap = schemeIconsView else {
            return
        }

        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.image = UIImage(named: "\(scheme)-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        schemeIconsViewUnwrap.addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    private func addFillerView() {
        guard let schemeIconsViewUnwrap = schemeIconsView else {
            return
        }
        let fillerView = UIView()
        fillerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fillerView.backgroundColor = .clear
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsViewUnwrap.addArrangedSubview(fillerView)
    }

}
