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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyInitialization() {
        let detailsInputView = DetailsInputView()
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let detailsInputView = DetailsInputView(coder: coder)
    }

    func testFrameInitialization() {
        let detailsInputView = DetailsInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
    }

}
