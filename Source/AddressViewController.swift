import Foundation

public class AddressViewController: UIViewController, CountrySelectionViewControllerDelegate {

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
    /// Delegate
    public weak var delegate: AddressViewControllerDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameInputView.label?.text = "Name"
        countryRegionInputView.label?.text = "Country/Region"
        organizationInputView.label?.text = "Organization"
        streetAddressInputView.label?.text = "Street address"
        postalTownInputView.label?.text = "Postal Town"
        postcodeInputView.label?.text = "Postcode"
        phoneInputView.label?.text = "Phone"
        // set color of background inputs
        nameInputView.backgroundColor = .white
        countryRegionInputView.backgroundColor = .white
        organizationInputView.backgroundColor = .white
        streetAddressInputView.backgroundColor = .white
        postalTownInputView.backgroundColor = .white
        postcodeInputView.backgroundColor = .white
        phoneInputView.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(onTapDoneButton))

        // add gesture recognizer
        countryRegionTapGesture.addTarget(self, action: #selector(onTapCountryRegionView))
        countryRegionInputView.addGestureRecognizer(countryRegionTapGesture)

        countrySelectionViewController.delegate = self
        self.view.backgroundColor = UIColor.groupTableViewBackground
        stackView.axis = .vertical
        stackView.spacing = 16

        // add views
        stackView.addArrangedSubview(nameInputView)
        stackView.addArrangedSubview(countryRegionInputView)
        stackView.addArrangedSubview(organizationInputView)
        stackView.addArrangedSubview(streetAddressInputView)
        stackView.addArrangedSubview(postalTownInputView)
        stackView.addArrangedSubview(postcodeInputView)
        stackView.addArrangedSubview(phoneInputView)
        self.view.addSubview(stackView)

        // add constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor, constant: 16).isActive = true
    }

    @objc func onTapCountryRegionView() {
        navigationController?.pushViewController(countrySelectionViewController, animated: true)
    }

    @objc func onTapDoneButton() {
        let address = Address(addressLine1: streetAddressInputView.textField?.text,
                              addressLine2: nil,
                              postcode: postcodeInputView.textField?.text,
                              country: countryRegionInputView.value?.text,
                              city: nil,
                              state: nil,
                              phone: nil)
        self.delegate?.onTapDoneButton(address: address)
        navigationController?.popViewController(animated: true)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func onCountrySelected(country: String) {
        countryRegionInputView.value!.text = country
    }

}
