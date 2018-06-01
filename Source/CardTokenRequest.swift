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

    public init(number: String, expiryMonth: Int, expiryYear: Int,
                name: String?, cvv: String?, billingAdress: Address?,
                phone: PhoneNumber?) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.name = name
        self.cvv = cvv
        self.billingAdress = billingAdress
        self.phone = phone
    }

    public init(number: String, expiryMonth: Int, expiryYear: Int, cvv: String?) {
        self.number = number
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvv = cvv
        self.name = nil
        self.billingAdress = nil
        self.phone = nil
    }
}
