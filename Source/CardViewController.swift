import Foundation

/// A view controller that allows the user to enter card information.
public class CardViewController: UIViewController, AddressViewControllerDelegate, UITextFieldDelegate {

    let cardUtils = CardUtils()

    var scrollView: UIScrollView {
        let scrollView = UIScrollView.init(frame: view.bounds)
        scrollView.contentSize = CGSize(width: self.view., height: <#T##CGFloat#>)
        return scrollView
    }
    let scrollContentView = UIView()
    let stackView = UIStackView()
    let schemeIconsView = UIStackView()
    let acceptedCardLabel = UILabel()
    let cardNumberInputView = CardNumberInputView()
    let cardHolderNameInputView = StandardInputView()
    let expirationDateInputView = ExpirationDateInputView()
    let cvvInputView = StandardInputView()
    let billingDetailsInputView = DetailsInputView()
    var billingDetailsAddress: Address?

    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!

    var scrollViewHeightConstraint: NSLayoutConstraint!

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
        addConstraints()
        addTextFieldsDelegate()

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

        self.view.backgroundColor = UIColor.groupTableViewBackground
        acceptedCardLabel.backgroundColor = UIColor.purple
        schemeIconsView.backgroundColor = UIColor.purple
        stackView.backgroundColor = UIColor.purple
        schemeIconsView.spacing = 8
        stackView.axis = .vertical
        stackView.spacing = 16
    }

    private func addViews() {
        stackView.addArrangedSubview(cardNumberInputView)
        stackView.addArrangedSubview(cardHolderNameInputView)
        stackView.addArrangedSubview(expirationDateInputView)
        stackView.addArrangedSubview(cvvInputView)
        stackView.addArrangedSubview(billingDetailsInputView)
        self.scrollView.addSubview(acceptedCardLabel)
        self.scrollView.addSubview(schemeIconsView)
        self.scrollView.addSubview(stackView)
        self.view.addSubview(scrollView)
    }

    private func addConstraints() {
        acceptedCardLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptedCardLabel.trailingAnchor
            .constraint(equalTo: self.scrollView.safeTrailingAnchor, constant: -16)
            .isActive = true
        acceptedCardLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 16).isActive = true
        acceptedCardLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16).isActive = true

        schemeIconsView.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsView.trailingAnchor.constraint(equalTo: self.scrollView.safeTrailingAnchor, constant: -16).isActive = true
        schemeIconsView.topAnchor.constraint(equalTo: acceptedCardLabel.bottomAnchor, constant: 16).isActive = true
        schemeIconsView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: self.schemeIconsView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.blue
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeTopAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeBottomAnchor).isActive = true
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
        if keyboardHeight != nil {
            return
        }

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height

            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
//                self.scrollViewBottomConstraint.constant += self.keyboardHeight
//                print(self.scrollViewBottomConstraint.constant)
                self.scrollView.layoutIfNeeded()
//                self.constraintContentHeight.constant += self.keyboardHeight
            })

            // move if keyboard hide input field
            guard let activeField = UIResponder.current as? UITextField else { return }
            let distanceToBottom = self.scrollView.frame.size.height - (activeField.frame.origin.y)
                - (activeField.frame.size.height)
            let collapseSpace = keyboardHeight - distanceToBottom

            if collapseSpace < 0 {
                // no collapse
                return
            }

            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: 0, y: collapseSpace + 10)
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
//            self.constraintContentHeight.constant -= self.keyboardHeight
//            self.scrollViewBottomConstraint.constant -= self.keyboardHeight
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }

        keyboardHeight = nil
    }

}
