//
//  AddressViewControllerTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class AddressViewControllerMockDelegate: AddressViewControllerDelegate {

    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWith: Address?

    func onTapDoneButton(address: Address) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWith = address
    }

}

class AddressViewControllerTests: XCTestCase {

    var addressViewController: AddressViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addressViewController = AddressViewController()
        let navigation = UINavigationController()
        navigation.viewControllers = [addressViewController]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func setupAddress() {
        addressViewController.regionCodeSelected = "FR"
        addressViewController.addressLine1InputView.textField.text = "12 rue de la boulangerie"
        addressViewController.cityInputView.textField.text = "Lyon"
        addressViewController.zipInputView.textField.text = "69002"
    }

    func testInitialization() {
        let addressViewController = AddressViewController()
        addressViewController.viewDidLoad()
        XCTAssertEqual(addressViewController.navigationItem.rightBarButtonItem?.isEnabled, false)
    }

    func testAddHandlersInViewWillAppear() {
        addressViewController.notificationCenter = NotificationCenterMock()
        addressViewController.viewWillAppear(true)
        if let notificationCenterMock = addressViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 2)
            XCTAssertEqual(notificationCenterMock.handlers[0].name, NSNotification.Name.UIKeyboardWillShow)
            XCTAssertEqual(notificationCenterMock.handlers[1].name, NSNotification.Name.UIKeyboardWillHide)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testRemoveHandlersInViewWillDisappear() {
        addressViewController.notificationCenter = NotificationCenterMock()
        // Add the handlers
        testAddHandlersInViewWillAppear()
        // Remove the handlers
        addressViewController.viewWillDisappear(true)
        if let notificationCenterMock = addressViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 0)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testScrollViewOnKeyboardWillShow() {
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo: [
                UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])

        addressViewController.scrollViewOnKeyboardWillShow(notification: notification,
                                                           scrollView: addressViewController.scrollView,
                                                           activeField: addressViewController.phoneInputView.textField)
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 380, right: 0.0)
        XCTAssertEqual(addressViewController.scrollView.contentInset, contentInsets)
    }

    func testScrollViewOnKeyboardWillHide() {
        testScrollViewOnKeyboardWillShow()
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        addressViewController.scrollViewOnKeyboardWillHide(notification: notification,
                                                           scrollView: addressViewController.scrollView)
        let contentInsets = UIEdgeInsets.zero
        XCTAssertEqual(addressViewController.scrollView.contentInset, contentInsets)
    }

    func testKeyboardWillShow() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let addressVC = AddressViewControllerMock(coder: coder)
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        addressVC?.keyboardWillShow(notification: notification)
        XCTAssertEqual(addressVC?.kbShowCalledTimes, 1)
        XCTAssertEqual(addressVC?.kbShowLastCalledWith?.0, notification)
        XCTAssertEqual(addressVC?.kbShowLastCalledWith?.1, addressVC?.scrollView)
    }

    func testKeyboardWillHide() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let addressVC = AddressViewControllerMock(coder: coder)
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        addressVC?.keyboardWillHide(notification: notification)
        XCTAssertEqual(addressVC?.kbHideCalledTimes, 1)
        XCTAssertEqual(addressVC?.kbHideLastCalledWith?.0, notification)
        XCTAssertEqual(addressVC?.kbHideLastCalledWith?.1, addressVC?.scrollView)
    }

    func testDisableDoneButtonIfFormNotValid() {
        addressViewController.viewDidLoad()
        addressViewController.textFieldDidEndEditing(UITextField())
        XCTAssertFalse((addressViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testEnableDoneButtonIfFormIsValid() {
        // Setup
        addressViewController.viewDidLoad()
        setupAddress()
        // Assert
        addressViewController.textFieldDidEndEditing(UITextField())
        XCTAssertTrue((addressViewController.navigationItem.rightBarButtonItem?.isEnabled)!)
    }

    func testCallDelegateMethodOnTapDoneButton() {
        let delegate = AddressViewControllerMockDelegate()
        addressViewController.delegate = delegate
        setupAddress()
        addressViewController.onTapDoneButton()
        XCTAssertEqual(delegate.onTapDoneButtonCalledTimes, 1)
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.addressLine1, "12 rue de la boulangerie")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.city, "Lyon")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.country, "FR")
        XCTAssertEqual(delegate.onTapDoneButtonLastCalledWith?.zip, "69002")
    }
}
