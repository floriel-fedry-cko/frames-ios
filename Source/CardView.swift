import Foundation

public class CardView: UIView {

    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    let schemeIconsStackView = SchemeIconsStackView()
    let acceptedCardLabel = UILabel()
    let addressTapGesture = UITapGestureRecognizer()

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

    // Input options
    let cardHolderNameState: InputState
    let billingDetailsState: InputState

    var scrollViewBottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        cardHolderNameState = .required
        billingDetailsState = .required
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        cardHolderNameState = .required
        billingDetailsState = .required
        super.init(coder: aDecoder)
        setup()
    }

    init(cardHolderNameState: InputState, billingDetailsState: InputState) {
        self.cardHolderNameState = cardHolderNameState
        self.billingDetailsState = billingDetailsState
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addViews()
        addInitialConstraints()
        self.backgroundColor = UIColor.groupTableViewBackground
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

        schemeIconsStackView.spacing = 8
        stackView.axis = .vertical
        stackView.spacing = 16
        // keyboard
        var textFields = [cardNumberInputView.textField,
                          expirationDateInputView.textField,
                          cvvInputView.textField]
        if cardHolderNameState != .hidden {
            textFields.insert(cardHolderNameInputView.textField, at: 1)
        }
        addKeyboardToolbarNavigation(textFields: textFields)
    }

    private func addViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(acceptedCardLabel)
        contentView.addSubview(schemeIconsStackView)
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

    private func addInitialConstraints() {
        scrollViewBottomConstraint = self.addScrollViewContraints(scrollView: scrollView, contentView: contentView)
        acceptedCardLabel.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        acceptedCardLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -16)
            .isActive = true
        acceptedCardLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        acceptedCardLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        acceptedCardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            .isActive = true

        schemeIconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            .isActive = true
        schemeIconsStackView.topAnchor.constraint(equalTo: acceptedCardLabel.bottomAnchor, constant: 16).isActive = true
        schemeIconsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: schemeIconsStackView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
