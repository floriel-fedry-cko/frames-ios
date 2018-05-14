import Foundation

/// Customer card list
public struct CustomerCardList: Decodable {
    /// Number of cards
    public let count: Int
    /// Cards associated to the customer
    public let data: [CustomerCard]
}
