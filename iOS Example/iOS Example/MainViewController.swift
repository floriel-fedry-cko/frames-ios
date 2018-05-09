import UIKit
import PassKit
import CheckoutSdkIos

class MainViewController: UIViewController {

    let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    let merchantId = "merchant.com.checkout.sdk"

    @IBOutlet weak var schemeIconsView: UIStackView!
    @IBOutlet weak var cardNumberInputView: CardNumberInputView!
    @IBOutlet weak var expirationDateInputView: ExpirationDateInputView!
    @IBOutlet weak var cvvInputView: StandardInputView!

    @IBOutlet weak var payButtonView: UIStackView!

    
    @IBAction func onTapBillingAddress(_ sender: Any) {
        
    }
    
    @IBAction func onTapPayButton(_ sender: Any) {
        guard
            let cardNumber = cardNumberInputView.textField!.text,
            let expirationDate = expirationDateInputView.textField!.text,
            let cvv = cvvInputView.textField!.text
            else { return }
        let (expiryMonth, expiryYear) = cardUtils.standardize(expirationDate: expirationDate)
        let card = CardRequest(number: cardUtils.standardize(cardNumber: cardNumber),
                               expiryMonth: expiryMonth,
                               expiryYear: expiryYear,
                               cvv: cvv,
                               name: nil)
        checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
            let alert = UIAlertController(title: "Payment successful",
                                          message: "Your card token: \(cardToken.id)", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Payment unsuccessful",
                                          message: "Error: \(error)", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        })
    }

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

        // Apple Pay Button
        let buttonType: PKPaymentButtonType = PKPaymentAuthorizationController.canMakePayments() ? .buy : .setUp
        let applePayButton = PKPaymentButton(paymentButtonType: buttonType, paymentButtonStyle: .black)
        applePayButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        applePayButton.addTarget(self, action: #selector(onTouchApplePayButton), for: .touchUpInside)
        payButtonView.addArrangedSubview(applePayButton)
    }

    @objc func onTouchApplePayButton() {
        if PKPaymentAuthorizationController.canMakePayments() {
            let paymentRequest = createPaymentRequest()
            if let applePayViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                self.present(applePayViewController, animated: true)
            }
        }
    }

    private func createPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()

        paymentRequest.currencyCode = "GBP"
        paymentRequest.countryCode = "GB"
        paymentRequest.merchantIdentifier = merchantId
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex, .discover, .JCB]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.paymentSummaryItems = getProductsToSell()

        let sameDayShipping = PKShippingMethod(label: "Same Day Shipping", amount: 4.99)
        sameDayShipping.detail = "Same day guaranteed delivery"
        sameDayShipping.identifier = "sameDay"

        let twoDayShipping = PKShippingMethod(label: "Two Day Shipping", amount: 2.99)
        twoDayShipping.detail = "Delivered within the following 2 days"
        twoDayShipping.identifier = "twoDay"

        let oneWeekShipping = PKShippingMethod(label: "Same day", amount: 0.99)
        oneWeekShipping.detail = "Delivered within 1 week"
        oneWeekShipping.identifier = "oneWeek"

        paymentRequest.shippingMethods = [sameDayShipping, twoDayShipping, oneWeekShipping]

        return paymentRequest
    }

    private func getProductsToSell() -> [PKPaymentSummaryItem] {
        let demoProduct1 = PKPaymentSummaryItem(label: "Demo Product 1", amount: 9.99)
        let demoDiscount = PKPaymentSummaryItem(label: "Demo Discount", amount: 2.99)
        let shipping = PKPaymentSummaryItem(label: "Shipping", amount: 14.99)

        let totalAmount = demoProduct1.amount.adding(demoDiscount.amount)
        let totalPrice = PKPaymentSummaryItem(label: "Checkout.com", amount: totalAmount)

        return [demoProduct1, demoDiscount, shipping, totalPrice]
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
