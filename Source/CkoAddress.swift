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

    /// Initialize `CkoAddress`
    ///
    /// - parameter name: Name
    /// - parameter addressLine1: Line 1
    /// - parameter addressLine2: Line 2
    /// - parameter city: City
    /// - parameter state: State
    /// - parameter postcode: Postcode
    /// - parameter country: Country
    /// - parameter phone: Phone
    ///
    ///
    /// - returns: The new `CkoAddress` instance
    public init(name: String?, addressLine1: String?, addressLine2: String?, city: String?, state: String?,
                postcode: String?, country: String?, phone: CkoPhoneNumber?) {
        self.name = name
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.postcode = postcode
        self.country = country
        self.phone = phone
    }
}
