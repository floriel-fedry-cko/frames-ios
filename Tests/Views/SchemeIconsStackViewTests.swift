import XCTest
@testable import CheckoutSdkIos

class SchemeIconsStackViewTests: XCTestCase {

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
        let schemeIconsStackView = SchemeIconsStackView(coder: coder)
        XCTAssertNotNil(schemeIconsStackView)
        XCTAssertFalse(schemeIconsStackView.translatesAutoresizingMaskIntoConstraints)
    }

    func testFrameInitialization() {
        let schemeIconsStackView = SchemeIconsStackView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertFalse(schemeIconsStackView.translatesAutoresizingMaskIntoConstraints)
    }
}
