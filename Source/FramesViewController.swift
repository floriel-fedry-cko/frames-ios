import Foundation

/// A view controller that allows the user to enter card information.
public class FramesViewController: UIViewController,
    CardNumberInputViewDelegate,
UITextFieldDelegate {

    // MARK: - Properties

    let cardUtils = CardUtils()
    public var framesView: FramesView!
    var notificationCenter = NotificationCenter.default

    /// List of available schemes
    public var availableSchemes: [CardScheme] = [.visa, .mastercard, .americanExpress, .dinersClub]

    /// Delegate
    public weak var delegate: CardViewControllerDelegate?

    // Scheme Icons
    private var lastSelected: UIImageView?

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        framesView = FramesView(frame: .zero)

        addTextFieldsDelegate()

        // add schemes icons
        framesView.schemeIconsStackView.setIcons(schemes: availableSchemes)
        // add keyboard toolbar
        let textFields = [framesView.cardNumberInputView.textField,
                          framesView.expirationDateInputView.textField,
                          framesView.cvvInputView.textField]
        addKeyboardToolbarNavigation(textFields: textFields)
    }

    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardHandlers(notificationCenter: notificationCenter,
                                      keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }

    public override func viewDidLayoutSubviews() {
        self.view.addSubview(framesView)
        framesView.translatesAutoresizingMaskIntoConstraints = false
        self.framesView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        self.framesView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
        self.framesView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        self.framesView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    }

    @objc func onTapDoneCardButton() {
        // Get the values
        let cardNumber = framesView.cardNumberInputView.textField.text!
        let expirationDate = framesView.expirationDateInputView.textField.text!
        let cvv = framesView.cvvInputView.textField.text!

        let cardNumberStandardized = cardUtils.standardize(cardNumber: cardNumber)
        // Validate the values
        guard
            let cardType = cardUtils.getTypeOf(cardNumber: cardNumberStandardized)
            else { return }
        let (expiryMonth, expiryYear) = cardUtils.standardize(expirationDate: expirationDate)
        // card number invalid
        let isCardNumberValid = cardUtils.isValid(cardNumber: cardNumberStandardized, cardType: cardType)
        let isExpirationDateValid = cardUtils.isValid(expirationMonth: expiryMonth, expirationYear: expiryYear)
        let isCvvValid = cardUtils.isValid(cvv: cvv, cardType: cardType)

        // TODO: Check if the card type is amongst the valid ones

        if !isCardNumberValid {
            let message = NSLocalizedString("cardNumberInvalid", bundle: Bundle(for: CardViewController.self),
                                            comment: "")
            framesView.cardNumberInputView.showError(message: message)
        }
        if !isCvvValid {
            let message = NSLocalizedString("cvvInvalid", bundle: Bundle(for: CardViewController.self), comment: "")
            framesView.cvvInputView.showError(message: message)
        }
        if !isCardNumberValid || !isExpirationDateValid || !isCvvValid { return }

        let card = CardTokenRequest(number: cardNumberStandardized,
                                    expiryMonth: Int(expiryMonth)!,
                                    expiryYear: Int(expiryYear)!,
                                    name: nil,
                                    cvv: cvv, billingAddress: nil, phone: nil)
        self.delegate?.onTapDone(card: card)
        navigationController?.popViewController(animated: true)
    }

    private func addTextFieldsDelegate() {
        framesView.cardNumberInputView.delegate = self
        framesView.expirationDateInputView.textField.delegate = self
        framesView.cvvInputView.delegate = self
    }

    private func validateFieldsValues() {
        let cardNumber = framesView.cardNumberInputView.textField.text!
        let expirationDate = framesView.expirationDateInputView.textField.text!
        let cvv = framesView.cvvInputView.textField.text!

        // values are not empty strings
        if cardNumber.isEmpty || expirationDate.isEmpty ||
            cvv.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        self.scrollViewOnKeyboardWillShow(notification: notification,
                                          scrollView: framesView.scrollView,
                                          activeField: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollViewOnKeyboardWillHide(notification: notification, scrollView: framesView.scrollView)
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
    }

    public func textFieldDidEndEditing(view: UIView) {
        validateFieldsValues()
        if let superView = view as? CardNumberInputView {
            let cardNumber = superView.textField.text!
            let cardNumberStandardized = cardUtils.standardize(cardNumber: cardNumber)
            let cardType = cardUtils.getTypeOf(cardNumber: cardNumberStandardized)
            framesView.cvvInputView.cardType = cardType
        }
    }

    // MARK: - CardNumberInputViewDelegate

    /// Called when the card number changed.
    public func onChange(cardType: CardType?) {
        // reset if the card number is empty
        if cardType == nil && lastSelected != nil {
            framesView.schemeIconsStackView.arrangedSubviews.forEach { $0.alpha = 1 }
            lastSelected = nil
        }
        guard let type = cardType else { return }
        let index = availableSchemes.index(of: type.scheme)
        guard let indexScheme = index else { return }
        let imageView = framesView.schemeIconsStackView.arrangedSubviews[indexScheme] as? UIImageView

        if lastSelected == nil {
            framesView.schemeIconsStackView.arrangedSubviews.forEach { $0.alpha = 0.5 }
            imageView?.alpha = 1
            lastSelected = imageView
        } else {
            lastSelected!.alpha = 0.5
            imageView?.alpha = 1
            lastSelected = imageView
        }
    }

}
