import Foundation

/// Phone
public struct Phone: Codable {
    /// Country Code
    public let countryCode: String?
    /// Phone number (without country code)
    public let number: String?
}
