//
//  CvvConfirmationViewController.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 18/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class ViewControllerDelegateMock: CvvConfirmationViewControllerDelegate {

    var onConfirmCalledTimes = 0
    var onConfirmLastCalledWith: (CvvConfirmationViewController, String)?

    var onCancelCalledTimes = 0
    var onCancelLastCalledWith: CvvConfirmationViewController?

    func onConfirm(controller: CvvConfirmationViewController, cvv: String) {
        onConfirmCalledTimes += 1
        onConfirmLastCalledWith = (controller, cvv)
    }

    func onCancel(controller: CvvConfirmationViewController) {
        onCancelCalledTimes += 1
        onCancelLastCalledWith = controller
    }
}

class CvvConfirmationViewControllerTests: XCTestCase {

    var cvvConfirmationViewController: CvvConfirmationViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cvvConfirmationViewController = CvvConfirmationViewController()
        cvvConfirmationViewController.viewDidLoad()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        /// Empty constructor
        let cvvConfirmationViewController = CvvConfirmationViewController()
        cvvConfirmationViewController.viewDidLoad()
        XCTAssertEqual(cvvConfirmationViewController.view.subviews.count, 1)
    }

    func testCallDelegateOnConfirmCvv() {
        let delegate = ViewControllerDelegateMock()
        cvvConfirmationViewController.delegate = delegate
        cvvConfirmationViewController.textField.text = "100"
        cvvConfirmationViewController.onConfirmCvv()
        XCTAssertEqual(delegate.onConfirmCalledTimes, 1)
        XCTAssertEqual(delegate.onConfirmLastCalledWith?.0, cvvConfirmationViewController)
        XCTAssertEqual(delegate.onConfirmLastCalledWith?.1, "100")
    }

    func testCallDelegateOnCancel() {
        let delegate = ViewControllerDelegateMock()
        cvvConfirmationViewController.delegate = delegate
        cvvConfirmationViewController.onCancel()
        XCTAssertEqual(delegate.onCancelCalledTimes, 1)
        XCTAssertEqual(delegate.onCancelLastCalledWith, cvvConfirmationViewController)
    }
}
