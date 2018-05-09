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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countrySelectionViewController.delegate = self
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
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func onCountrySelected(country: String) {
        countryRegionInputView.value!.text = country
    }
    
    
}
