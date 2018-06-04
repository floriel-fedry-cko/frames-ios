import UIKit
import PassKit
import CheckoutSdkIos

class ExampleViewController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            CardViewControllerDelegate,
                            ThreeDsWebViewControllerDelegate {

    @IBOutlet weak var cardsTableView: UITableView!
    var cardsTableViewHeightConstraint: NSLayoutConstraint?

    let publicKey = "pk_test_03728582-062b-419c-91b5-63ac2a481e07"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    let merchantAPIClient = MerchantAPIClient()
    let customerEmail = "just@test.com"

    var customerCardList: CustomerCardList?
    var createdCards: [CardRequest] = []
    var selectedCard: Any?

    let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .normal)
    let threeDsViewController = ThreeDsWebViewController(
        successUrl: "https://github.com/floriel-fedry-cko/just-a-test/",
        failUrl: "https://github.com/floriel-fedry-cko/just-a-test/master/"
    )
    let simpleLoadingViewController = SimpleLoadingViewController()

    @IBAction func onTapAddCard(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    @IBAction func onTapPayWithCard(_ sender: Any) {
        if let card = selectedCard as? CustomerCard {
            merchantAPIClient.payWith3ds(value: 509, cardId: card.id, cvv: "100", customer: customerEmail) { response in
                self.threeDsViewController.url = response.redirectUrl
                self.present(self.threeDsViewController, animated: true)
            }
        }
    }

    func addOkAlertButton(alert: UIAlertController) {
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup table view
        cardsTableView.register(CardListCell.self, forCellReuseIdentifier: "cardCell")
        cardViewController.delegate = self
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        cardsTableViewHeightConstraint = cardsTableView.heightAnchor
            .constraint(equalToConstant: self.cardsTableView.contentSize.height)
        cardsTableViewHeightConstraint?.isActive = true
        // set 3ds delegate
        threeDsViewController.delegate = self

        updateCustomerCardList()
    }

    func updateCustomerCardList() {
        self.present(simpleLoadingViewController, animated: false, completion: nil)
        merchantAPIClient.get(customer: customerEmail) { customer in
            self.customerCardList = customer.cards
            self.cardsTableView.reloadData()
            self.cardsTableViewHeightConstraint?.constant = self.cardsTableView.contentSize.height * 1.2
            self.dismiss(animated: true, completion: nil)
            // select the default card
            let indexDefaultCardOpt = customer.cards.data.index { card in
                card.id == customer.defaultCard
            }
            guard let indexDefaultCard = indexDefaultCardOpt else { return }
            let indexPath = IndexPath(row: indexDefaultCard, section: 0)
            self.cardsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }

    func onTapDone(card: CardTokenRequest) {
        self.cardsTableViewHeightConstraint?.constant = self.cardsTableView.contentSize.height
        checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
            // Get the card token and call the merchant api to do a zero dollar authorization charge
            // This will verify the card and save it to the customer
            self.merchantAPIClient.save(cardWith: cardToken.token, for: self.customerEmail, isId: false) {
                // update the customer card list with the new card
                self.updateCustomerCardList()
            }
        }, errorHandler: { error in
            let alert = UIAlertController(title: "Payment unsuccessful",
                                          message: "Error: \(error)", preferredStyle: .alert)
            self.addOkAlertButton(alert: alert)
            self.present(alert, animated: true, completion: nil)
        })
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerCardCount = customerCardList?.count ?? 0
        if indexPath.row < customerCardCount {
            guard let card = customerCardList?.data[indexPath.row] else { return }
            selectedCard = card
        } else {
            selectedCard = createdCards[indexPath.row - customerCardCount]
        }
    }

    func onSuccess3D() {
        print("dismissed 😎")
    }

    func onFailure3D() {
        print("dismissed 😢")
    }

}
