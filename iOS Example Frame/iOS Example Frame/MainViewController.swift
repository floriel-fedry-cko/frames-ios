//
//  ViewController.swift
//  iOS Example Frame
//
//  Created by Floriel Fedry on 11/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import UIKit
import CheckoutSdkIos

class MainViewController: UIViewController, CardViewControllerDelegate {

    var checkoutAPIClient: CheckoutAPIClient {
        return CheckoutAPIClient(publicKey: "pk_test_03728582-062b-419c-91b5-63ac2a481e07",
                                 environment: .sandbox)
    }

    let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .hidden)

    @IBAction func onClickGoToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardViewController.delegate = self
        cardViewController.rightBarButtonItem = UIBarButtonItem(title: "Pay", style: .done, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onTapDone(card: CardTokenRequest) {
        checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
            self.showAlert(with: cardToken.token)
        }, errorHandler: { error in
            print(error)
        })
    }

    private func showAlert(with cardToken: String) {
        let alert = UIAlertController(title: "Payment",
                                      message: cardToken, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
