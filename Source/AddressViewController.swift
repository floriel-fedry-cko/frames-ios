import Foundation

/// A view controller that allows the user to enter address information.
public class AddressViewController: UIViewController, CountrySelectionViewControllerDelegate, UITextFieldDelegate {

    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    let nameInputView = StandardInputView()
    let countryRegionInputView = DetailsInputView()
    let organizationInputView = StandardInputView()
    let streetAddressInputView = StandardInputView()
    let postalTownInputView = StandardInputView()
    let postcodeInputView = StandardInputView()
    let phoneInputView = StandardInputView()

    let countrySelectionViewController = CountrySelectionViewController()
    let countryRegionTapGesture = UITapGestureRecognizer()

    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                     target: self, action: nil)
    var scrollViewBottomConstraint: NSLayoutConstraint!
    var notificationCenter: NotificationCenter = NotificationCenter.default

    /// Delegate
    public weak var delegate: AddressViewControllerDelegate?

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        setInputViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(onTapDoneButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        // add gesture recognizer
        countryRegionTapGesture.addTarget(self, action: #selector(onTapCountryRegionView))
        countryRegionInputView.addGestureRecognizer(countryRegionTapGesture)

        countrySelectionViewController.delegate = self
        self.view.backgroundColor = UIColor.groupTableViewBackground
        stackView.axis = .vertical
        stackView.spacing = 16

        addViews()
        addConstraints()
        addTextFieldsDelegate()
        addKeyboardToolbarNavigation(textFields: [
            nameInputView.textField,
            organizationInputView.textField,
            streetAddressInputView.textField,
            postalTownInputView.textField,
            postcodeInputView.textField,
            phoneInputView.textField
            ])
    }

    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardHandlers(notificationCenter: notificationCenter,
                                      keyboardWillShow: #selector(keyboardWillShow),
                                      keyboardWillHide: #selector(keyboardWillHide))
    }

    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterKeyboardHandlers(notificationCenter: notificationCenter)
    }

    // MARK: - Methods

    @objc func keyboardWillShow(notification: NSNotification) {
        self.scrollViewOnKeyboardWillShow(notification: notification, scrollView: scrollView, activeField: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollViewOnKeyboardWillHide(notification: notification, scrollView: scrollView)
    }

    @objc func onTapCountryRegionView() {
        navigationController?.pushViewController(countrySelectionViewController, animated: true)
    }

    @objc func onTapDoneButton() {
        let address = Address(addressLine1: streetAddressInputView.textField.text,
                              addressLine2: nil,
                              postcode: postcodeInputView.textField.text,
                              country: countryRegionInputView.value.text,
                              city: nil,
                              state: nil,
                              phone: nil)
        self.delegate?.onTapDoneButton(address: address)
        navigationController?.popViewController(animated: true)
    }

    private func setInputViews() {
        nameInputView.set(label: "name", backgroundColor: .white)
        countryRegionInputView.set(label: "countryRegion", backgroundColor: .white)
        organizationInputView.set(label: "organization", backgroundColor: .white)
        streetAddressInputView.set(label: "streetAddress", backgroundColor: .white)
        postalTownInputView.set(label: "postalTown", backgroundColor: .white)
        postcodeInputView.set(label: "postcode", backgroundColor: .white)
        phoneInputView.set(label: "phone", backgroundColor: .white)
        // set content type
        organizationInputView.textField.textContentType = .organizationName
        streetAddressInputView.textField.textContentType = .fullStreetAddress
        postalTownInputView.textField.textContentType = .addressCity
        postcodeInputView.textField.textContentType = .postalCode
        phoneInputView.textField.textContentType = .telephoneNumber
        // set keyboard
        phoneInputView.textField.keyboardType = .phonePad
    }

    private func addViews() {
        stackView.addArrangedSubview(nameInputView)
        stackView.addArrangedSubview(countryRegionInputView)
        stackView.addArrangedSubview(organizationInputView)
        stackView.addArrangedSubview(streetAddressInputView)
        stackView.addArrangedSubview(postalTownInputView)
        stackView.addArrangedSubview(postcodeInputView)
        stackView.addArrangedSubview(phoneInputView)
        contentView.addSubview(stackView)
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
    }

    private func addConstraints() {
        scrollViewBottomConstraint = self.addScrollViewContraints(scrollView: scrollView, contentView: contentView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.contentView.safeTrailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: self.contentView.safeTopAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.safeLeadingAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.safeBottomAnchor).isActive = true
    }

    private func addTextFieldsDelegate() {
        streetAddressInputView.textField.delegate = self
        postalTownInputView.textField.delegate = self
        postcodeInputView.textField.delegate = self
        phoneInputView.textField.delegate = self
    }

    private func validateFieldsValues() {
        /// required values are not nil
        guard
            let countryRegion = countryRegionInputView.value.text,
            let streetAddress = streetAddressInputView.textField.text,
            let postalTown = postalTownInputView.textField.text,
            let postcode = postcodeInputView.textField.text,
            let phone = phoneInputView.textField.text
            else {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
        }
        /// required values are not empty
        if
            countryRegion.isEmpty ||
            streetAddress.isEmpty ||
            postalTown.isEmpty ||
            postcode.isEmpty ||
            phone.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    // MARK: - CountrySelectionViewControllerDelegate

    /// Executed when an user select a country.
    public func onCountrySelected(country: String) {
        countryRegionInputView.value.text = country
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
    }

}
