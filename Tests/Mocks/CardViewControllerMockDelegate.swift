import XCTest
@testable import CheckoutSdkIos

class CardViewControllerMockDelegate: CardViewControllerDelegate {
    var calledTimes = 0
    var lastCalledWith: CkoCardTokenRequest?

    func onTapDone(card: CkoCardTokenRequest) {
        calledTimes += 1
        lastCalledWith = card
    }
}
