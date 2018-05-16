//
//  CardNumberInputViewTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class CardNumberInputViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyInitialization() {
        let cardNumberInputView = CardNumberInputView()
        XCTAssertEqual(cardNumberInputView.textField?.textContentType, .creditCardNumber)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardNumberInputView = CardNumberInputView(coder: coder)
        XCTAssertNotNil(cardNumberInputView)
        XCTAssertEqual(cardNumberInputView?.textField?.textContentType, .creditCardNumber)
    }

    func testFrameInitialization() {
        let cardNumberInputView = CardNumberInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(cardNumberInputView.textField?.textContentType, .creditCardNumber)
    }

    func testTextFormatCardNumberPasting() {
        let cardNumber = "4242424242424242"
        let expectedText = "4242 4242 4242 4242"
        let cardNumberInputView = CardNumberInputView()
        _ = cardNumberInputView.textField(cardNumberInputView.textField!,
                                      shouldChangeCharactersIn: NSRange(),
                                      replacementString: cardNumber)
        XCTAssertEqual(cardNumberInputView.textField?.text, expectedText)
    }

    func testTextNotChangingAboveMaxLength() {
        let expectedText = "4242 4242 4242 4242"
        let cardNumberInputView = CardNumberInputView()
        _ = cardNumberInputView.textField(cardNumberInputView.textField!,
                                          shouldChangeCharactersIn: NSRange(),
                                          replacementString: "424242424242424")
        XCTAssertEqual(cardNumberInputView.textField?.text, "4242 4242 4242 424")
        // add a characters below the max length of a visa card
        _ = cardNumberInputView.textField(cardNumberInputView.textField!,
                                          shouldChangeCharactersIn: NSRange(),
                                          replacementString: "2")
        XCTAssertEqual(cardNumberInputView.textField?.text, expectedText)
        // add a characters above the max length of a visa card
        _ = cardNumberInputView.textField(cardNumberInputView.textField!,
                                          shouldChangeCharactersIn: NSRange(),
                                          replacementString: "4")
        XCTAssertEqual(cardNumberInputView.textField?.text, expectedText)
    }

}
