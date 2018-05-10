import UIKit
import PassKit
import CheckoutSdkIos

class StartViewController: UIViewController {

    let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    let cardViewController = CardViewController()

    @IBAction func onTapAddCard(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
