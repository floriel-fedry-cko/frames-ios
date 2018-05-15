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

    let merchantAPIClient = MerchantAPIClient()
    let customerId = "cust_B81EA007-0A12-4E68-9312-39CE171029D5"

    var customerCardList: CustomerCardList?
    var createdCards: [CardRequest] = []

    let cardViewController = CardViewController()

    @IBAction func onTapAddCard(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cardsTableView.register(CardListCell.self, forCellReuseIdentifier: "cardCell")
        cardViewController.delegate = self
        cardsTableView.delegate = self
        cardsTableView.dataSource = self

        merchantAPIClient.get(customer: customerId) { customer in
            self.customerCardList = customer.cards
            self.cardsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onTapDone(card: CardRequest) {
        print(card)
        createdCards.append(card)
        cardsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let customerCardCount = customerCardList?.count ?? 0
        return createdCards.count + customerCardCount
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardListCell
            else { fatalError("The dequeued cell is not an instance of CardCell.")}
        let customerCardCount = customerCardList?.count ?? 0
        if indexPath.row < customerCardCount {
            // customer card
            guard let card = customerCardList?.data[indexPath.row] else { return cell }
            cell.cardInfoLabel.text = "\(card.paymentMethod.capitalized) ····\(card.last4)"
            cell.nameLabel.text = card.name
            if let cardScheme = CardScheme(rawValue: card.paymentMethod.lowercased()) {
                cell.setSchemeIcon(scheme: cardScheme)
            }
        } else {
            return renderCreatedCard(row: indexPath.row, cell: cell)
        }
        return cell
    }

    private func renderCreatedCard(row: Int, cell: CardListCell) -> UITableViewCell {
        // created card
        let customerCardCount = customerCardList?.count ?? 0
        guard row - customerCardCount < createdCards.count else { return cell }
        let card = createdCards[row - customerCardCount]
        let cardType = cardUtils.getTypeOf(cardNumber: card.number)
        if let cardTypeUnwrap = cardType {
            let last4Index = card.number.index(card.number.endIndex, offsetBy: -4)
            let last4 = card.number[last4Index...]
            cell.cardInfoLabel.text = "\(cardTypeUnwrap.name.capitalized) ····\(last4)"
            if let cardScheme = CardScheme(rawValue: cardTypeUnwrap.name.lowercased()) {
                cell.setSchemeIcon(scheme: cardScheme)
            }
        }
        cell.nameLabel.text = card.name
        return cell
    }
}
