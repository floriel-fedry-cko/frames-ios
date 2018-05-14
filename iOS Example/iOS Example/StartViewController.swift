import UIKit
import PassKit
import CheckoutSdkIos

class StartViewController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
CardViewControllerDelegate {

    @IBOutlet weak var cardsTableView: UITableView!

    let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    var cards: [CardRequest] = [
        CardRequest(number: "4242424242424242",
                    expiryMonth: "11",
                    expiryYear: "18",
                    cvv: "100",
                    name: "Mat Okon"),
        CardRequest(number: "4242424242424242",
                    expiryMonth: "11",
                    expiryYear: "18",
                    cvv: "100",
                    name: "Mat Okon"),
        CardRequest(number: "4242424242424242",
                    expiryMonth: "11",
                    expiryYear: "18",
                    cvv: "100",
                    name: "Mat Okon")
    ]

    let cardViewController = CardViewController()

    @IBAction func onTapAddCard(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cardsTableView.register(CardCell.self, forCellReuseIdentifier: "cardCell")
        cardViewController.delegate = self
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onTapDone(card: CardRequest) {
        print(card)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardCell
            else { fatalError("The dequeued cell is not an instance of CardCell.")}
        let card = cards[indexPath.row]
        guard let cardType = cardUtils.getTypeOf(cardNumber: card.number) else {
            fatalError("The card number does not correspond to a known scheme.")
        }
        cell.cardInformationLabel?.text = "\(cardType.name.capitalized) \(424242)"
        cell.cardholderNameLabel?.text = card.name

        return cell
    }
}
