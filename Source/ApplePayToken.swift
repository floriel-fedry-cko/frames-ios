import Foundation

/// Apple Pay token
public struct ApplePayToken: Decodable {
    /// Token that can be used to process a _Charge with Card Token_
    public let token: String
}
