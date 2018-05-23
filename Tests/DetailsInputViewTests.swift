//
//  DetailsInputViewTests.swift
//  CheckoutSdkIosTests
//
//  Created by Floriel Fedry on 15/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest
@testable import CheckoutSdkIos

class DetailsInputViewTests: XCTestCase {

    var detailsInputView = DetailsInputView()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        detailsInputView = DetailsInputView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyInitialization() {
        _ = DetailsInputView()
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        _ = DetailsInputView(coder: coder)
    }

    func testFrameInitialization() {
        _ = DetailsInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
    }

    func testSetText() {
        detailsInputView.text = "Text"
        XCTAssertEqual(detailsInputView.label.text, "Text")
    }

    func testSetLabelAndBackgroundColor() {
        detailsInputView.set(label: "streetAddress", backgroundColor: .white)
        XCTAssertEqual(detailsInputView.label.text, "Street Address*")
        XCTAssertEqual(detailsInputView.backgroundColor, UIColor.white)
    }
}
