import Foundation

/// A view controller that allows the user to enter address information.
public class AddressViewController: UIViewController, CountrySelectionViewControllerDelegate, UITextFieldDelegate {

    // MARK: - Properties

    var addressView: AddressView!
    let countrySelectionViewController = CountrySelectionViewController()
    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                     target: self, action: nil)
    var notificationCenter: NotificationCenter = NotificationCenter.default
    var regionCodeSelected: String?

    /// Delegate
    public weak var delegate: AddressViewControllerDelegate?

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        addressView = AddressView(frame: .zero)
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(addressView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(onTapDoneButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
        // add gesture recognizer
        addressView.countryRegionTapGesture.addTarget(self, action: #selector(onTapCountryRegionView))
        addressView.countryRegionInputView.addGestureRecognizer(addressView.countryRegionTapGesture)
        countrySelectionViewController.delegate = self
        addTextFieldsDelegate()
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

    /// Called to notify the view controller that its view has just laid out its subviews.
    public override func viewDidLayoutSubviews() {
        self.view.addSubview(addressView)
        addressView.translatesAutoresizingMaskIntoConstraints = false
        self.addressView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        self.addressView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
        self.addressView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        self.addressView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    // MARK: - Methods

    @objc func keyboardWillShow(notification: NSNotification) {
        self.scrollViewOnKeyboardWillShow(notification: notification,
                                          scrollView: addressView.scrollView,
                                          activeField: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollViewOnKeyboardWillHide(notification: notification, scrollView: addressView.scrollView)
    }

    @objc func onTapCountryRegionView() {
        navigationController?.pushViewController(countrySelectionViewController, animated: true)
    }

    @objc func onTapDoneButton() {
        let address = Address(addressLine1: addressView.addressLine1InputView.textField.text,
                              addressLine2: addressView.addressLine2InputView.textField.text,
                              city: addressView.cityInputView.textField.text,
                              state: addressView.stateInputView.textField.text,
                              zip: addressView.zipInputView.textField.text,
                              country: regionCodeSelected)
        self.delegate?.onTapDoneButton(address: address)
        navigationController?.popViewController(animated: true)
    }

    private func addTextFieldsDelegate() {
        addressView.addressLine1InputView.textField.delegate = self
        addressView.addressLine2InputView.textField.delegate = self
        addressView.cityInputView.textField.delegate = self
        addressView.zipInputView.textField.delegate = self
        addressView.phoneInputView.textField.delegate = self
    }

    private func validateFieldsValues() {
        /// required values are not nil
        guard
            let countryRegion = regionCodeSelected,
            let streetAddress = addressView.addressLine1InputView.textField.text,
            let postalTown = addressView.cityInputView.textField.text,
            let postcode = addressView.zipInputView.textField.text
            else {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
        }
        /// required values are not empty
        if
            countryRegion.isEmpty ||
            streetAddress.isEmpty ||
            postalTown.isEmpty ||
            postcode.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    // MARK: - CountrySelectionViewControllerDelegate

    /// Executed when an user select a country.
    public func onCountrySelected(country: String, regionCode: String) {
        regionCodeSelected = regionCode
        addressView.countryRegionInputView.value.text = country
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFieldsValues()
    }

}
