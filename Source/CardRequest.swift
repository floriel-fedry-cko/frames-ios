import Foundation

/// Card used to create the card token
public struct CardRequest {

    /// Initialize `CardRequest`
    ///
    /// - parameter number: Card number
    /// - parameter expiryMonth: Expiry month
    /// - parameter expiryYear: Expiry year
    /// - parameter cvv: CVV (card verification value)
    /// - parameter name: Name of the card owner
    ///
    ///
    /// - returns: The new `CardRequest` instance
    public init(number: String, expiryMonth: String, expiryYear: String, cvv: String, name: String?) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
        self.name = name
    }

    /// Card number
    public let number: String
    /// Expiry month
    public let expiryMonth: String
    /// Expiry year
    public let expiryYear: String
    /// CVV (card verification value
    public let cvv: String
    /// Name of the card owner
    public let name: String?

    /// Get the struct represented as a dictionary of its values
    ///
    /// - returns: Dictionary representation of the struct
    public func toDictionary() -> [String: Any] {
        return [
            "number": self.number,
            "expiryMonth": self.expiryMonth,
            "expiryYear": self.expiryYear,
            "cvv": self.cvv,
            "name": self.name ?? ""
        ]
    }
}
