import Foundation

/// A view controller that allows the user to enter card information.
public class CardViewController: UIViewController, AddressViewControllerDelegate, UITextFieldDelegate {

    let cardUtils = CardUtils()

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    let schemeIconsView = UIStackView()
    let acceptedCardLabel = UILabel()
    let cardNumberInputView = CardNumberInputView()
    let cardHolderNameInputView = StandardInputView()
    let expirationDateInputView = ExpirationDateInputView()
    let cvvInputView = StandardInputView()
    let billingDetailsInputView = DetailsInputView()
    var billingDetailsAddress: Address?

    var scrollViewBottomConstraint: NSLayoutConstraint!

    let addressViewController = AddressViewController()
    let addressTapGesture = UITapGestureRecognizer()

    var availableSchemes: [CardScheme] = [.visa, .mastercard, .americanExpress, .dinersClub]

    /// Delegate
    public weak var delegate: CardViewControllerDelegate?

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
        self.registerKeyboardHandlers(keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterKeyboardHandlers()
    }

    @objc func onTapAddressView() {
        navigationController?.pushViewController(addressViewController, animated: true)
    }

    @objc func onTapDoneCardButton() {
        // Get the values
        guard
            let cardNumber = cardNumberInputView.textField.text,
            let expirationDate = expirationDateInputView.textField.text,
            let cvv = cvvInputView.textField.text
            else { return }
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
        _ = validateFieldsValues()
    }

    private func setupUIViews() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        acceptedCardLabel.text = "Accepted Cards"
        cardNumberInputView.set(label: "cardNumber", backgroundColor: .white)
        cardHolderNameInputView.set(label: "cardholderName", backgroundColor: .white)
        expirationDateInputView.set(label: "expirationDate", backgroundColor: .white)
        cvvInputView.set(label: "cvv", backgroundColor: .white)
        billingDetailsInputView.set(label: "billingDetails", backgroundColor: .white)
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
        stackView.addArrangedSubview(cardHolderNameInputView)
        stackView.addArrangedSubview(expirationDateInputView)
        stackView.addArrangedSubview(cvvInputView)
        stackView.addArrangedSubview(billingDetailsInputView)
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
        cvvInputView.textField.delegate = self
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

    private func validateFieldsValues() -> Bool {
        // values are not nil
        guard
            let cardNumber = cardNumberInputView.textField.text,
            let cardholdersName = cardHolderNameInputView.textField.text,
            let expirationDate = expirationDateInputView.textField.text,
            let cvv = cvvInputView.textField.text,
            billingDetailsAddress != nil
            else {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return false
        }
        // values are not empty strings
        if cardNumber.isEmpty || cardholdersName.isEmpty || expirationDate.isEmpty ||
            cvv.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return false
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
        return true
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        _ = validateFieldsValues()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        self.scrollViewOnKeyboardWillShow(notification: notification, scrollView: scrollView)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollViewOnKeyboardWillHide(notification: notification, scrollView: scrollView)
    }

}
