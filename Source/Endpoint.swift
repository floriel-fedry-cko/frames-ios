import Foundation

/// List of the api enpoints.
///
/// - cardProviders: used to get the list of card providers.
/// - createCardToken: used to create a card token.
/// - createApplePayToken: used to create a card token with Apple Pay.
enum Endpoint: String {
    case cardProviders = "providers/cards"
    case createCardToken = "tokens/card"
    case createApplePayToken = "applepay/token"
}
