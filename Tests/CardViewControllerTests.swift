//
//  CardViewControllerTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class CardViewControllerTests: XCTestCase {

    var cardViewController: CardViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cardViewController = CardViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let cardViewController = CardViewController()
        cardViewController.viewDidLoad()
    }

    func testAddHandlersInViewWillAppear() {
        cardViewController.notificationCenter = NotificationCenterMock()
        cardViewController.viewWillAppear(true)
        if let notificationCenterMock = cardViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 2)
            XCTAssertEqual(notificationCenterMock.handlers[0].name, NSNotification.Name.UIKeyboardWillShow)
            XCTAssertEqual(notificationCenterMock.handlers[1].name, NSNotification.Name.UIKeyboardWillHide)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testRemoveHandlersInViewWillDisappear() {
        cardViewController.notificationCenter = NotificationCenterMock()
        // Add the handlers
        testAddHandlersInViewWillAppear()
        // Remove the handlers
        cardViewController.viewWillDisappear(true)
        if let notificationCenterMock = cardViewController.notificationCenter as? NotificationCenterMock {
            XCTAssertEqual(notificationCenterMock.handlers.count, 0)
        } else {
            XCTFail("Notification center is not a mock")
        }
    }

    func testKeyboardWillShow() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardVC = CardViewControllerMock(coder: coder)
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        cardVC?.keyboardWillShow(notification: notification)
        XCTAssertEqual(cardVC?.kbShowCalledTimes, 1)
        XCTAssertEqual(cardVC?.kbShowLastCalledWith?.0, notification)
        XCTAssertEqual(cardVC?.kbShowLastCalledWith?.1, cardVC?.scrollView)
    }

    func testKeyboardWillHide() {
        /// Mock Address View Controller
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardVC = CardViewControllerMock(coder: coder)
        let notification = NSNotification(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo: [
            UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: 300))
            ])
        cardVC?.keyboardWillHide(notification: notification)
        XCTAssertEqual(cardVC?.kbHideCalledTimes, 1)
        XCTAssertEqual(cardVC?.kbHideLastCalledWith?.0, notification)
        XCTAssertEqual(cardVC?.kbHideLastCalledWith?.1, cardVC?.scrollView)
    }
}
