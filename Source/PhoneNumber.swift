import Foundation

/// A phone number
public struct PhoneNumber: Codable {

    /// The international country calling code. Required for some risk checks.
    public let countryCode: String?

    /// The phone number
    public let number: String?

    public init(countryCode: String? = nil, number: String? = nil) {
        self.countryCode = countryCode
        self.number = number
    }

}
