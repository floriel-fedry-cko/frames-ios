import Foundation

/// Apple Pay Header Data
public struct ApplePayHeaderData {

    /// Initialize `ApplePayHeaderData`
    ///
    /// - parameter publicKeyHash: Hash of the X.509 encoded public key bytes of the merchant’s certificate
    /// - parameter transactionId: Transaction identifier, generated on the device
    /// - parameter applicationData: Hash of the applicationData property of the original PKPaymentRequestObject
    /// - parameter ephemeralPublicKey: Ephemeral public key bytes. EC_v1 only
    /// - parameter wrappedKey: Rsa_v1 only. The symmetric key wrapped using your RSA public key
    ///
    ///
    /// - returns: The new `ApplePayHeaderData` instance
    public init(publicKeyHash: String, transactionId: String, applicationData: String?,
                ephemeralPublicKey: String?, wrappedKey: String?) {
        self.publicKeyHash = publicKeyHash
        self.transactionId = transactionId
        self.applicationData = applicationData
        self.ephemeralPublicKey = ephemeralPublicKey
        self.wrappedKey = wrappedKey
    }

    /// Hash of the applicationData property of the original PKPaymentRequestObject
    public let applicationData: String?
    /// Ephemeral public key bytes. EC_v1 only
    public let ephemeralPublicKey: String?
    /// Rsa_v1 only. The symmetric key wrapped using your RSA public key
    public let wrappedKey: String?
    /// Hash of the X.509 encoded public key bytes of the merchant’s certificate
    public let publicKeyHash: String
    /// Transaction identifier, generated on the device
    public let transactionId: String

    /// Get the struct represented as a dictionary of its values
    ///
    /// - returns: Dictionary representation of the struct
    public func toDictionary() -> [String: Any] {
        return [
            "applicationData": applicationData ?? "",
            "ephemeralPublicKey": ephemeralPublicKey ?? "",
            "wrappedKey": wrappedKey ?? "",
            "publicKeyHash": publicKeyHash,
            "transactionId": transactionId
        ]
    }
}
