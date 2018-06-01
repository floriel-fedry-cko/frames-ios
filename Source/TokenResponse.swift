import Foundation

public struct TokenResponse: Codable {
    public let type: String
    public let token: String
    public let expiresOn: String
}
