import Foundation

/// A view controller that allows the user to enter card information.
public class CardViewController: UIViewController,
    AddressViewControllerDelegate,
    CardNumberInputViewDelegate,
    UITextFieldDelegate {

    // MARK: - Properties

    let cardUtils = CardUtils()

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    let schemeIconsView = UIStackView()
    let acceptedCardLabel = UILabel()

    /// Card number input view
    public let cardNumberInputView = CardNumberInputView()

    /// Card holder's name input view
    public let cardHolderNameInputView = StandardInputView()

    /// Expiration date input view
    public let expirationDateInputView = ExpirationDateInputView()

    /// Cvv input view
    public let cvvInputView = CvvInputView()

    /// Billing details input view
    public let billingDetailsInputView = DetailsInputView()

    var billingDetailsAddress: Address?
    var scrollViewBottomConstraint: NSLayoutConstraint!
    var notificationCenter = NotificationCenter.default
    let addressViewController = AddressViewController()
    let addressTapGesture = UITapGestureRecognizer()

    /// List of available schemes
    public var availableSchemes: [CardScheme] = [.visa, .mastercard, .americanExpress, .dinersClub]

    /// Delegate
    public weak var delegate: CardViewControllerDelegate?

    // Input options
    let cardHolderNameState: InputState
    let billingDetailsState: InputState

    // Scheme Icons
    private var lastSelected: UIImageView?

    // MARK: - Initialization

    /// Returns a newly initialized view controller with the cardholder's name and billing details
    /// state specified.
    public init(cardHolderNameState: InputState, billingDetailsState: InputState) {
        self.cardHolderNameState = cardHolderNameState
        self.billingDetailsState = billingDetailsState
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        cardHolderNameState = .required
        billingDetailsState = .required
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        cardHolderNameState = .required
        billingDetailsState = .required
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUIViews()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(onTapDoneCardButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        // add gesture recognizer
        addressTapGesture.addTarget(self, action: #selector(onTapAddressView))
        billingDetailsInputView.addGestureRecognizer(addressTapGesture)

        addressViewController.delegate = self

        addViews()
        addTextFieldsDelegate()
        addConstraints()

        // add schemes icons
        availableSchemes.forEach { scheme in
            self.addSchemeIcon(scheme: scheme)
        }
        self.addFillerView()

        addKeyboardToolbarNavigation(textFields: [
            cardNumberInputView.textField,
            cardHolderNameInputView.textField,
            expirationDateInputView.textField,
            cvvInputView.textField
            ])
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardHandlers(notificationCenter: notificationCenter,
                                      keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    }

    @objc func onTapAddressView() {
        navigationController?.pushViewController(addressViewController, animated: true)
    }

    @objc func onTapDoneCardButton() {
        // Get the values
        let cardNumber = cardNumberInputView.textField.text!
        let expirationDate = expirationDateInputView.textField.text!
        let cvv = cvvInputView.textField.text!

        let cardNumberStandardized = cardUtils.standardize(cardNumber: cardNumber)
        // Validate the values
        guard
            let cardType = cardUtils.getTypeOf(cardNumber: cardNumberStandardized)
            else { return }
        let (expiryMonth, expiryYear) = cardUtils.standardize(expirationDate: expirationDate)
        guard
            cardUtils.isValid(cardNumber: cardNumberStandardized, cardType: cardType),
            cardUtils.isValid(expirationMonth: expiryMonth, expirationYear: expiryYear),
            cardUtils.isValid(cvv: cvv, cardType: cardType)
            else { return }

        let card = CardRequest(number: cardNumberStandardized, expiryMonth: expiryMonth, expiryYear: expiryYear,
                               cvv: cvv, name: cardHolderNameInputView.textField.text)
        self.delegate?.onTapDone(card: card)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - AddressViewControllerDelegate

    /// Executed when an user tap on the done button.
    public func onTapDoneButton(address: Address) {
        billingDetailsAddress = address
        let value = "\(address.addressLine1 ?? ""), \(address.addressLine2 ?? ""), \(address.city ?? "")"
        billingDetailsInputView.value.text = value
        validateFieldsValues()
    }

    private func setupUIViews() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        acceptedCardLabel.text = "Accepted Cards"
        cardNumberInputView.set(label: "cardNumber", backgroundColor: .white)
        if cardHolderNameState == .required {
            cardHolderNameInputView.set(label: "cardholderNameRequired", backgroundColor: .white)
        } else {
            cardHolderNameInputView.set(label: "cardholderName", backgroundColor: .white)
        }
        expirationDateInputView.set(label: "expirationDate", backgroundColor: .white)
        cvvInputView.set(label: "cvv", backgroundColor: .white)
        if billingDetailsState == .required {
            billingDetailsInputView.set(label: "billingDetailsRequired", backgroundColor: .white)
        } else {
            billingDetailsInputView.set(label: "billingDetails", backgroundColor: .white)
        }
        cardNumberInputView.textField.placeholder = "4242"
        expirationDateInputView.textField.placeholder = "06/2020"
        cvvInputView.textField.placeholder = "100"
        cvvInputView.textField.keyboardType = .numberPad

        schemeIconsView.spacing = 8
        stackView.axis = .vertical
        stackView.spacing = 16
    }

    private func addViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(acceptedCardLabel)
        contentView.addSubview(schemeIconsView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(cardNumberInputView)
        if cardHolderNameState != .hidden {
            stackView.addArrangedSubview(cardHolderNameInputView)
        }
        stackView.addArrangedSubview(expirationDateInputView)
        stackView.addArrangedSubview(cvvInputView)
        if billingDetailsState != .hidden {
            stackView.addArrangedSubview(billingDetailsInputView)
        }
    }

    private func addConstraints() {
        scrollViewBottomConstraint = self.addScrollViewContraints(scrollView: scrollView, contentView: contentView)
        acceptedCardLabel.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        acceptedCardLabel.trailingAnchor
            .constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
            .isActive = true
        acceptedCardLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        acceptedCardLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
            .isActive = true

        schemeIconsView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
            .isActive = true
        schemeIconsView.topAnchor.constraint(equalTo: acceptedCardLabel.bottomAnchor, constant: 16).isActive = true
        schemeIconsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true

        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: self.schemeIconsView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }

    private func addTextFieldsDelegate() {
        cardNumberInputView.delegate = self
        cardHolderNameInputView.textField.delegate = self
        expirationDateInputView.textField.delegate = self
        cvvInputView.delegate = self
    }

    private func addSchemeIcon(scheme: CardScheme) {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let image = UIImage(named: "schemes/icon-\(scheme.rawValue)", in: Bundle(for: CardViewController.self),
                compatibleWith: nil)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        schemeIconsView.addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    private func addFillerView() {
        let fillerView = UIView()
        fillerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fillerView.backgroundColor = .clear
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsView.addArrangedSubview(fillerView)
    }

    private func validateFieldsValues() {
        // values are not nil
        let cardNumber = cardNumberInputView.textField.text!
        let expirationDate = expirationDateInputView.textField.text!
        let cvv = cvvInputView.textField.text!

        // check card holder's name
        if cardHolderNameState == .required && (cardHolderNameInputView.textField.text?.isEmpty)! {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        // check billing details
        if billingDetailsState == .required && billingDetailsAddress == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        // values are not empty strings
        if cardNumber.isEmpty || expirationDate.isEmpty ||
            cvv.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        self.scrollViewOnKeyboardWillShow(notification: notification, scrollView: scrollView, activeField: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollViewOnKeyboardWillHide(notification: notification, scrollView: scrollView)
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
        if textField.superview is CardNumberInputView {
            let cardNumber = textField.text!
            let cardNumberStandardized = cardUtils.standardize(cardNumber: cardNumber)
            let cardType = cardUtils.getTypeOf(cardNumber: cardNumberStandardized)
            cvvInputView.cardType = cardType
        }
    }

    // MARK: - CardNumberInputViewDelegate

    public func onChange(cardType: CardType?) {
        // reset if the card number is empty
        if cardType == nil && lastSelected != nil {
            schemeIconsView.arrangedSubviews.forEach { $0.alpha = 1 }
            lastSelected = nil
        }
        guard let type = cardType else { return }
        let index = availableSchemes.index(of: type.scheme)
        guard let indexScheme = index else { return }
        let imageView = schemeIconsView.arrangedSubviews[indexScheme] as? UIImageView

        if lastSelected == nil {
            schemeIconsView.arrangedSubviews.forEach { $0.alpha = 0.5 }
            imageView?.alpha = 1
            lastSelected = imageView
        } else {
            lastSelected!.alpha = 1
            imageView?.alpha = 0.5
            lastSelected = imageView
        }
    }

}
