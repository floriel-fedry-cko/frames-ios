import Foundation

/// Address View displaying a form to enter address information.
public class AddressView: UIView {

    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()

    let addressLine1InputView = StandardInputView()
    let addressLine2InputView = StandardInputView()
    let cityInputView = StandardInputView()
    let stateInputView = StandardInputView()
    let zipInputView = StandardInputView()
    let phoneInputView = StandardInputView()
    let countryRegionInputView = DetailsInputView()

    let countrySelectionViewController = CountrySelectionViewController()
    let countryRegionTapGesture = UITapGestureRecognizer()

    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                     target: self, action: nil)
    var scrollViewBottomConstraint: NSLayoutConstraint!
    var notificationCenter: NotificationCenter = NotificationCenter.default
    var regionCodeSelected: String?

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.backgroundColor = UIColor.groupTableViewBackground
        stackView.axis = .vertical
        stackView.spacing = 16
        addViews()
        addInitialConstraints()
        countryRegionInputView.set(label: "countryRegion", backgroundColor: .white)
        addressLine1InputView.set(label: "streetAddress", backgroundColor: .white)
        addressLine2InputView.set(label: "streetAddress", backgroundColor: .white)
        cityInputView.set(label: "postalTown", backgroundColor: .white)
        stateInputView.set(label: "state", backgroundColor: .white)
        zipInputView.set(label: "postcode", backgroundColor: .white)
        phoneInputView.set(label: "phone", backgroundColor: .white)
        // set content type
        addressLine1InputView.textField.textContentType = .streetAddressLine1
        addressLine2InputView.textField.textContentType = .streetAddressLine2
        cityInputView.textField.textContentType = .addressCity
        stateInputView.textField.textContentType = UITextContentType.addressState
        zipInputView.textField.textContentType = .postalCode
        phoneInputView.textField.textContentType = .telephoneNumber
        // set keyboard
        phoneInputView.textField.keyboardType = .phonePad

        addKeyboardToolbarNavigation(textFields: [
            addressLine1InputView.textField,
            addressLine2InputView.textField,
            cityInputView.textField,
            stateInputView.textField,
            zipInputView.textField,
            phoneInputView.textField
            ])
    }

    private func addViews() {
        stackView.addArrangedSubview(countryRegionInputView)
        stackView.addArrangedSubview(addressLine1InputView)
        stackView.addArrangedSubview(addressLine2InputView)
        stackView.addArrangedSubview(cityInputView)
        stackView.addArrangedSubview(stateInputView)
        stackView.addArrangedSubview(zipInputView)
        stackView.addArrangedSubview(phoneInputView)
        contentView.addSubview(stackView)
        scrollView.addSubview(contentView)
        self.addSubview(scrollView)
    }

    private func addInitialConstraints() {
        scrollViewBottomConstraint = self.addScrollViewContraints(scrollView: scrollView, contentView: contentView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.contentView.safeTrailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: self.contentView.safeTopAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.safeLeadingAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.safeBottomAnchor).isActive = true
    }
}
