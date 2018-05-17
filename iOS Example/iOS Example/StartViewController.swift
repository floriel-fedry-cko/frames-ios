import UIKit
import PassKit
import CheckoutSdkIos

class StartViewController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
CardViewControllerDelegate,
PKPaymentAuthorizationViewControllerDelegate {

    @IBOutlet weak var cardsTableView: UITableView!
    @IBOutlet weak var payButtonsView: UIStackView!
    var cardsTableViewHeightConstraint: NSLayoutConstraint?

    let publicKey = "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    let cardUtils = CardUtils()
    var availableSchemes: [CardScheme] = []

    let merchantAPIClient = MerchantAPIClient()
    let customerId = "cust_B81EA007-0A12-4E68-9312-39CE171029D5"
    let merchantId = "merchant.com.floriel"

    var customerCardList: CustomerCardList?
    var createdCards: [CardRequest] = []
    var selectedCard: Any?

    let cardViewController = CardViewController()

    @IBAction func onTapAddCard(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    @IBAction func onTapPayWithCard(_ sender: Any) {
        if let card = selectedCard as? CardRequest {
            // Newly created card
            checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
                let alert = UIAlertController(title: "Payment successful",
                                              message: "Your card token: \(cardToken.id)", preferredStyle: .alert)
                self.addOkAlertButton(alert: alert)
                self.present(alert, animated: true, completion: nil)
            }, errorHandler: { error in
                let alert = UIAlertController(title: "Payment unsuccessful",
                                              message: "Error: \(error)", preferredStyle: .alert)
                self.addOkAlertButton(alert: alert)
                self.present(alert, animated: true, completion: nil)
            })
        } else if let card = selectedCard as? CustomerCard {
            // Card from the merchant api
            let alert = UIAlertController(title: "Card id", message: "Your card id: \(card.id)", preferredStyle: .alert)
            self.addOkAlertButton(alert: alert)
            self.present(alert, animated: true, completion: nil)
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
        cardsTableView.register(CardListCell.self, forCellReuseIdentifier: "cardCell")
        cardViewController.delegate = self
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        cardsTableViewHeightConstraint = cardsTableView.heightAnchor
            .constraint(equalToConstant: self.cardsTableView.contentSize.height)
        cardsTableViewHeightConstraint?.isActive = true

        merchantAPIClient.get(customer: customerId) { customer in
            self.customerCardList = customer.cards
            self.cardsTableView.reloadData()
            self.cardsTableViewHeightConstraint?.constant = self.cardsTableView.contentSize.height * 2
            // select the default card
            let indexDefaultCardOpt = customer.cards.data.index { card in
                card.id == customer.defaultCard
            }
            guard let indexDefaultCard = indexDefaultCardOpt else { return }
            let indexPath = IndexPath(row: indexDefaultCard, section: 0)
            self.cardsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

        // Apple Pay Button
        let buttonType: PKPaymentButtonType = PKPaymentAuthorizationController.canMakePayments() ? .buy : .setUp
        let applePayButton = PKPaymentButton(paymentButtonType: buttonType, paymentButtonStyle: .black)
        applePayButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        applePayButton.addTarget(self, action: #selector(onTouchApplePayButton), for: .touchUpInside)
        payButtonsView.addArrangedSubview(applePayButton)
    }

    func onTapDone(card: CardRequest) {
        createdCards.append(card)
        cardsTableView.reloadData()
        self.cardsTableViewHeightConstraint?.constant = self.cardsTableView.contentSize.height * 2
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerCardCount = customerCardList?.count ?? 0
        if indexPath.row < customerCardCount {
            guard let card = customerCardList?.data[indexPath.row] else { return }
            selectedCard = card
        } else {
            selectedCard = createdCards[indexPath.row - customerCardCount]
        }
    }

    // View Controller

    @objc func onTouchApplePayButton() {
        if PKPaymentAuthorizationController.canMakePayments() {
            let paymentRequest = createPaymentRequest()
            if let applePayViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                applePayViewController.delegate = self
                self.present(applePayViewController, animated: true)
            }
        }
    }

    private func createPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()

        paymentRequest.currencyCode = "GBP"
        paymentRequest.countryCode = "GB"
        paymentRequest.merchantIdentifier = merchantId
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex, .discover, .JCB]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.paymentSummaryItems = getProductsToSell()

        let sameDayShipping = PKShippingMethod(label: "Same Day Shipping", amount: 4.99)
        sameDayShipping.detail = "Same day guaranteed delivery"
        sameDayShipping.identifier = "sameDay"

        let twoDayShipping = PKShippingMethod(label: "Two Day Shipping", amount: 2.99)
        twoDayShipping.detail = "Delivered within the following 2 days"
        twoDayShipping.identifier = "twoDay"

        let oneWeekShipping = PKShippingMethod(label: "Same day", amount: 0.99)
        oneWeekShipping.detail = "Delivered within 1 week"
        oneWeekShipping.identifier = "oneWeek"

        paymentRequest.shippingMethods = [sameDayShipping, twoDayShipping, oneWeekShipping]

        return paymentRequest
    }

    private func getProductsToSell() -> [PKPaymentSummaryItem] {
        let demoProduct1 = PKPaymentSummaryItem(label: "Demo Product 1", amount: 9.99)
        let demoDiscount = PKPaymentSummaryItem(label: "Demo Discount", amount: 2.99)
        let shipping = PKPaymentSummaryItem(label: "Shipping", amount: 14.99)

        let totalAmount = demoProduct1.amount.adding(demoDiscount.amount)
        let totalPrice = PKPaymentSummaryItem(label: "Checkout.com", amount: totalAmount)

        return [demoProduct1, demoDiscount, shipping, totalPrice]
    }

    // Delegate method Apple Pay

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        checkoutAPIClient.createApplePayToken(paymentData: payment.token.paymentData, successHandler: { applePayToken in
            print(applePayToken)
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }, errorHandler: { error in
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            print(error)
        })
    }

}
