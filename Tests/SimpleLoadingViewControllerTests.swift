import XCTest
@testable import CheckoutSdkIos

class SimpleLoadingViewControllerTests: XCTestCase {

    func testInitialization() {
        /// Empty constructor
        let simpleLoadingVC = SimpleLoadingViewController()
        simpleLoadingVC.viewDidLoad()
        XCTAssertEqual(simpleLoadingVC.view.subviews.count, 1)
    }

}
