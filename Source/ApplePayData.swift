import Foundation

/// Apple Pay required data to create a card token
public struct ApplePayData {

    /// Initialize `ApplePayData`
    ///
    /// - parameter version: Version information about the Apple Pay token
    /// - parameter paymentData: Payment Data optained with Apple Pay
    /// - parameter signature: Signature of the payment and header data
    /// - parameter header: Apple Pay Header data
    ///
    ///
    /// - returns: The new `ApplePayData` instance
    public init(version: String, paymentData: Data, signature: String, header: ApplePayHeaderData) {
        self.version = version
        self.paymentData = paymentData
        self.signature = signature
        self.header = header
    }

    /// Version information about the Apple Pay token
    public let version: String
    /// Payment Data optained with Apple Pay
    public let paymentData: Data
    /// Signature of the payment and header data
    public let signature: String
    /// Apple Pay Header data
    public let header: ApplePayHeaderData

    /// Get the struct represented as a dictionary of its values
    ///
    /// - returns: Dictionary representation of the struct
    public func toDictionary() -> [String: Any] {
        return [
            "version": version,
            "paymentData": String(data: paymentData, encoding: .utf8) as Any,
            "signature": signature,
            "header": header.toDictionary()
        ]
    }
}
