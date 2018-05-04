import UIKit
import PassKit
import CheckoutSdkIos

class ViewController: UIViewController, UITextFieldDelegate,
                                        PKPaymentAuthorizationViewControllerDelegate,
                                        ExpirationDatePickerDelegate {

    let merchantId = "merchant.com.checkout."
    let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardsUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var schemeIconsView: UIStackView!
    @IBOutlet weak var payButtonsView: UIStackView!
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardHolderField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    @IBOutlet weak var cvvField: UITextField!

    @IBOutlet var expirationDateTapGesture: UITapGestureRecognizer!
    @IBOutlet var cardNumberTapGesture: UITapGestureRecognizer!

    @IBAction func cardNumberViewTap(_ sender: UITapGestureRecognizer) {
        cardNumberField.becomeFirstResponder()
    }

    @IBAction func cardHolderViewTap(_ sender: UITapGestureRecognizer) {
        cardHolderField.becomeFirstResponder()
    }

    @IBAction func expirationDateViewTap(_ sender: UITapGestureRecognizer) {
        expirationDateField.becomeFirstResponder()
    }

    @IBAction func cvvViewTap(_ sender: UITapGestureRecognizer) {
        cvvField.becomeFirstResponder()
    }

    @IBAction func onTouchPayButton(_ sender: Any) {
        let cardNumber = cardsUtils.standardize(cardNumber: cardNumberField.text!)
        let (expiryMonth, expiryYear) = cardsUtils.standardize(expirationDate: expirationDateField.text!)
        let cvv = cvvField.text!
        let cardTypeOpt = cardsUtils.getTypeOf(cardNumber: cardNumber)
        guard let cardType = cardTypeOpt else { return }
        if !cardsUtils.isValid(cvv: cvv, cardType: cardType) {
            return
        }
        let card = CardRequest(number: cardNumber, expiryMonth: expiryMonth,
                               expiryYear: expiryYear, cvv: cvv, name: nil)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let expirationDatePicker = ExpirationDatePicker()
        expirationDatePicker.pickerDelegate = self
        expirationDateField.inputView = expirationDatePicker

        cardNumberField.delegate = self

        addKeyboardToolbarNavigation(textFields: [cardNumberField, cardHolderField, expirationDateField, cvvField])

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
        payButtonsView.addArrangedSubview(applePayButton)
    }

    func addKeyboardToolbarNavigation(textFields: [UITextField]) {
        // create the toolbar
        for (index, textField) in textFields.enumerated() {
            let toolbar = UIToolbar()
            let prevButton = UIBarButtonItem(image: UIImage(named: "keyboard-previous"),
                                             style: .plain, target: nil, action: nil)
            prevButton.width = 30
            let nextButton = UIBarButtonItem(image: UIImage(named: "keyboard-next"),
                                             style: .plain, target: nil, action: nil)
            let flexspace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                            target: nil, action: nil)

            var items = [prevButton, nextButton, flexspace]
            // first text field
            if index == 0 {
                prevButton.isEnabled = false
            } else {
                prevButton.target = textFields[index - 1]
                prevButton.action = #selector(UITextField.becomeFirstResponder)
            }

            // last text field
            if index == textFields.count - 1 {
                nextButton.isEnabled = false
                let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: textField,
                                                 action: #selector(UITextField.resignFirstResponder))
                items.append(doneButton)
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
                let downButton = UIBarButtonItem(image: UIImage(named: "keyboard-down"), style: .plain,
                                                 target: textField,
                                                 action: #selector(UITextField.resignFirstResponder))
                items.append(downButton)
            }
            toolbar.items = items
            toolbar.sizeToFit()
            textField.inputAccessoryView = toolbar
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // Card Number Formatting
        let cardNumber = cardsUtils.standardize(cardNumber: "\(cardNumberField!.text!)\(string)")
        if textField === cardNumberField {
            if string.isEmpty { return true }
            let cardType = cardsUtils.getTypeOf(cardNumber: cardNumber)
            guard let cardTypeUnwrap = cardType else { return false }
            guard cardNumber.count <= cardTypeUnwrap.validLengths.last! else {
                return false
            }
            cardNumberField!.text = cardsUtils.format(cardNumber: cardNumber, cardType: cardTypeUnwrap)
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func onDateChanged(month: String, year: String) {
        expirationDateField.text = "\(month)/\(year)"
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print(payment.token.paymentData)
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//        checkoutAPIClient.createApplePayToken(applePayData: <#T##ApplePayData#>, successHandler: { token in
//            print(token)
//        }, errorHandler: { error in
//            print(error)
//        })
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
