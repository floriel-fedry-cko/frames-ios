//
//  CardNumberInputViewTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class CardNumberInputViewMockDelegate: CardNumberInputViewDelegate {

    var onChangeTimes = 0
    var onChangeLastCalledWith: CardType?

    var textFieldDidEndEditingTimes = 0
    var textFieldDidEndEditingLastCalledWith: UIView?

    func onChange(cardType: CardType?) {
        onChangeTimes += 1
        onChangeLastCalledWith = cardType
    }

    func textFieldDidEndEditing(view: UIView) {
        textFieldDidEndEditingTimes += 1
        textFieldDidEndEditingLastCalledWith = view
    }
}

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
        XCTAssertEqual(cardNumberInputView.textField.textContentType, .creditCardNumber)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardNumberInputView = CardNumberInputView(coder: coder)
        XCTAssertNotNil(cardNumberInputView)
        XCTAssertEqual(cardNumberInputView?.textField.textContentType, .creditCardNumber)
    }

    func testFrameInitialization() {
        let cardNumberInputView = CardNumberInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(cardNumberInputView.textField.textContentType, .creditCardNumber)
    }

    func testTextFormatCardNumberPasting() {
        let cardNumber = "4242424242424242"
        let expectedText = "4242 4242 4242 4242"
        let cardNumberInputView = CardNumberInputView()
        cardNumberInputView.textField.text = cardNumber
        cardNumberInputView.textFieldDidChange(textField: cardNumberInputView.textField)
        XCTAssertEqual(cardNumberInputView.textField.text, expectedText)
    }

    func testTextNotChangingAboveMaxLength() {
        let cardNumberInputView = CardNumberInputView()
        var shouldChanged = cardNumberInputView.textField(cardNumberInputView.textField,
                                          shouldChangeCharactersIn: NSRange(),
                                          replacementString: "424242424242424")
        XCTAssertTrue(shouldChanged)
        cardNumberInputView.textField.text = "424242424242424"
        // add a characters below the max length of a visa card
        shouldChanged = cardNumberInputView.textField(cardNumberInputView.textField,
                                          shouldChangeCharactersIn: NSRange(),
                                          replacementString: "2")
        XCTAssertTrue(shouldChanged)
        cardNumberInputView.textField.text = "4242424242424242"
        // add a characters above the max length of a visa card
        shouldChanged = cardNumberInputView.textField(cardNumberInputView.textField,
                                          shouldChangeCharactersIn: NSRange(),
                                          replacementString: "4")
        XCTAssertFalse(shouldChanged)
    }

    func testReturnTrueIfStringEmpty() {
        let cardNumberInputView = CardNumberInputView()
        cardNumberInputView.textField.text = "4242 4242 4242 4242"
        let value = cardNumberInputView.textField(cardNumberInputView.textField,
                                                  shouldChangeCharactersIn: NSRange(),
                                                  replacementString: "")
        XCTAssertTrue(value)
    }

    func testCallDelegateMethodEndEditing() {
        let cardNumberInputView = CardNumberInputView()
        let cardNumberDelegate = CardNumberInputViewMockDelegate()
        cardNumberInputView.delegate = cardNumberDelegate
        cardNumberInputView.textFieldDidEndEditing(cardNumberInputView.textField)
        XCTAssertEqual(cardNumberDelegate.textFieldDidEndEditingTimes, 1)
        XCTAssertEqual(cardNumberDelegate.textFieldDidEndEditingLastCalledWith, cardNumberInputView)
    }

    func testHideErrorWhenTextfieldBeginEditing() {
        let cardNumberInputView = CardNumberInputView()
        cardNumberInputView.showError(message: "This is an error")
        XCTAssertEqual(cardNumberInputView.errorView.isHidden, false)
        cardNumberInputView.textFieldDidBeginEditing(cardNumberInputView.textField)
        XCTAssertEqual(cardNumberInputView.errorView.isHidden, true)
    }

}
