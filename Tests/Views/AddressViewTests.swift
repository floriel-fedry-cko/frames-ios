import XCTest
@testable import CheckoutSdkIos

class AddressViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let addressView = AddressView(coder: coder)
        XCTAssertNotNil(addressView)
        XCTAssertEqual(addressView?.stackView.arrangedSubviews.count, 8)
    }

    func testFrameInitialization() {
        let addressView = AddressView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(addressView.stackView.arrangedSubviews.count, 8)
    }
}
