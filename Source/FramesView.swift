import Foundation

/// View containing a simple payment form.
public class FramesView: UIView {
    var shouldSetupInitialConstraints = true

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    let schemeIconsStackView = SchemeIconsStackView()
    let acceptedCardLabel = UILabel()

    /// Card number input view
    public let cardNumberInputView = CardNumberInputView()

    /// Expiration date input view
    public let expirationDateInputView = ExpirationDateInputView()

    /// Cvv input view
    public let cvvInputView = CvvInputView()

    var scrollViewBottomConstraint: NSLayoutConstraint!


    private func setup() {
        schemeIconsStackView.spacing = 8
        stackView.axis = .vertical
        stackView.spacing = 16
        self.backgroundColor = UIColor.groupTableViewBackground
        acceptedCardLabel.text = "Accepted Cards"
        cardNumberInputView.set(label: "cardNumber", backgroundColor: .white)
        expirationDateInputView.set(label: "expirationDate", backgroundColor: .white)
        cvvInputView.set(label: "cvv", backgroundColor: .white)

        cardNumberInputView.textField.placeholder = "4242"
        expirationDateInputView.textField.placeholder = "06/2020"
        cvvInputView.textField.placeholder = "100"
        cvvInputView.textField.keyboardType = .numberPad
        addViews()
        addInitialConstraints()
    }

    private func addViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(acceptedCardLabel)
        contentView.addSubview(schemeIconsStackView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(cardNumberInputView)

        stackView.addArrangedSubview(expirationDateInputView)
        stackView.addArrangedSubview(cvvInputView)
    }

    private func addInitialConstraints() {
        scrollViewBottomConstraint = self.addScrollViewContraints(scrollView: scrollView, contentView: contentView)
        acceptedCardLabel.translatesAutoresizingMaskIntoConstraints = false
        schemeIconsStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        acceptedCardLabel.trailingAnchor
            .constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
            .isActive = true
        acceptedCardLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        acceptedCardLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        acceptedCardLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
            .isActive = true

        schemeIconsStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
            .isActive = true
        schemeIconsStackView.topAnchor.constraint(equalTo: acceptedCardLabel.bottomAnchor, constant: 16).isActive = true
        schemeIconsStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                      constant: 16).isActive = true

        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: self.schemeIconsStackView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}
