import Foundation

/// Apple Pay Token
public struct ApplePayTokenRequest: Codable {

    /// Token Type: Apple Pay
    let type = "applepay"

    /// The Apple Pay Payment Token
    public let tokenData: Data
}
