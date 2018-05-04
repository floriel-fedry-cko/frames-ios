import UIKit
import CheckoutSdkIos

class AddressViewController: UIViewController {

    @IBOutlet weak var input: StandardInputView!

    @IBAction func onTapButton(_ sender: Any) {

    }

    @IBAction func unwindSegueToAddressVC(_ sender: UIStoryboardSegue) {
        if sender.source is CountrySelectionViewController {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
