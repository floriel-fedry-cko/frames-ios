import Foundation

/// Address
public struct Address: Codable {
    /// Line 1
    public let addressLine1: String?
    /// Line 2
    public let addressLine2: String?
    /// Postcode
    public let postcode: String?
    /// Country
    public let country: String?
    /// City
    public let city: String?
    /// State
    public let state: String?
    /// Phone
    public let phone: Phone?
}
