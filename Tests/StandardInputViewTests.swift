//
//  StandardInputViewTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class StandardInputViewTests: XCTestCase {

    var standardInputView = StandardInputView()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        standardInputView = StandardInputView()
        let window = UIWindow()
        window.addSubview(standardInputView)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyInitialization() {
        let standardInputView = StandardInputView()
        XCTAssertEqual(standardInputView.textField.textContentType, UITextContentType.name)
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let standardInputView = StandardInputView(coder: coder)
        XCTAssertEqual(standardInputView!.textField.textContentType, UITextContentType.name)
    }

    func testFrameInitialization() {
        let standardInputView = StandardInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(standardInputView.textField.textContentType, UITextContentType.name)
    }

    func testTextFieldBecomeFirstResponderOnTap() {
        standardInputView.onTapView()
        XCTAssertTrue(self.standardInputView.textField.isFirstResponder)
    }

    func testSetTextAndBackgroundColor() {
        standardInputView.set(label: "streetAddress", backgroundColor: .white)
        XCTAssertEqual(standardInputView.label.text, "Street Address")
        XCTAssertEqual(standardInputView.backgroundColor, UIColor.white)
    }

    func testSetPlaceholder() {
        standardInputView.placeholder = "Placeholder"
        XCTAssertEqual(standardInputView.textField.placeholder, "Placeholder")
    }

    func testSetText() {
        standardInputView.text = "Text"
        XCTAssertEqual(standardInputView.label.text, "Text")
    }

}
