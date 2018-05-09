import UIKit
import CheckoutSdkIos

class AddressViewController: UIViewController, CountrySelectionViewControllerDelegate {

    @IBOutlet weak var nameInputView: StandardInputView!
    @IBOutlet weak var countryRegionInputView: DetailsInputView!
    @IBOutlet weak var organizationInputView: StandardInputView!
    @IBOutlet weak var streetAddressInputView: StandardInputView!
    @IBOutlet weak var postalTownInputView: StandardInputView!
    @IBOutlet weak var postalCodeInputView: StandardInputView!
    @IBOutlet weak var phoneInputView: StandardInputView!

    let countrySelectionViewController = CountrySelectionViewController()

    @IBAction func onTapCountryRegionInputView(_ sender: Any) {
        navigationController?.pushViewController(countrySelectionViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countrySelectionViewController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onCountrySelected(country: String) {
        countryRegionInputView.value!.text = country
    }

}
