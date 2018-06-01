import Foundation

public struct CardTokenRequest: Codable {
    public let type = "card"
    public let number: String
    public let expiryMonth: Int
    public let expiryYear: Int
    public let name: String?
    public let cvv: String?
    public let billingAdress: Address?
    public let phone: PhoneNumber?
}
