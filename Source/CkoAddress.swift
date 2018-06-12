import Foundation

/// Address
public struct CkoAddress: Codable {
    /// Name
    public let name: String?
    /// Line 1
    public let addressLine1: String?
    /// Line 2
    public let addressLine2: String?
    /// City
    public let city: String?
    /// State
    public let state: String?
    /// Postcode
    public let postcode: String?
    /// Country
    public let country: String?
    /// Phone
    public let phone: CkoPhoneNumber?
}
