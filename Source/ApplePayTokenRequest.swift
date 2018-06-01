import Foundation

public struct ApplePayTokenRequest: Codable {
    public let type = "applepay"
    public let tokenData: Data
}
