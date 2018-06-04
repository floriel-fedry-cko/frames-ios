import Foundation

/// A view controller that allows the user to enter address information.
public class AddressViewController: UIViewController, CountrySelectionViewControllerDelegate, UITextFieldDelegate {

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
            addressLine1InputView.textField,
            addressLine2InputView.textField,
            cityInputView.textField,
            stateInputView.textField,
            zipInputView.textField,
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
        let address = Address(addressLine1: addressLine1InputView.textField.text,
                              addressLine2: addressLine2InputView.textField.text,
                              city: cityInputView.textField.text,
                              state: stateInputView.textField.text,
                              zip: zipInputView.textField.text,
                              country: regionCodeSelected)
        self.delegate?.onTapDoneButton(address: address)
        navigationController?.popViewController(animated: true)
    }

    private func setInputViews() {
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
        addressLine1InputView.textField.delegate = self
        addressLine2InputView.textField.delegate = self
        cityInputView.textField.delegate = self
        zipInputView.textField.delegate = self
        phoneInputView.textField.delegate = self
    }

    private func validateFieldsValues() {
        /// required values are not nil
        guard
            let countryRegion = countryRegionInputView.value.text,
            let streetAddress = addressLine1InputView.textField.text,
            let postalTown = cityInputView.textField.text,
            let postcode = zipInputView.textField.text,
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
    public func onCountrySelected(country: String, regionCode: String) {
        regionCodeSelected = regionCode
        countryRegionInputView.value.text = country
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
    }

}
