import Foundation

/// Checkout API Client
/// used to call the api endpoint of Checkout API available with your public key
public class CheckoutAPIClient {

    // MARK: - Properties

    /// Checkout public key
    let publicKey: String

    /// Environment (sandbox or live)
    let environment: Environment

    /// headers used for the requests
    private var headers: [String: String] {
        return ["Authorization": self.publicKey]
    }

    // MARK: - Initialization

    /// Create an instance with the specified public key and environment
    ///
    /// - parameter publicKey: Checkout public key
    /// - parameter environment: Sandbox or Live (default to sandbox)
    ///
    ///
    /// - returns: The new `CheckoutAPIClient` instance
    public init(publicKey: String, environment: Environment = .sandbox) {
        self.publicKey = publicKey
        self.environment = environment
    }

    // MARK: - Methods

    /// Get the list of card providers
    /// The list will contains card schemes as well as alternative payments
    ///
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter errorHandler: Callback to execute if the request failed
    public func getCardProviders(successHandler: @escaping ([CardProvider]) -> Void,
                                 errorHandler: @escaping (Error) -> Void) {
        let url = "\(environment.urlApi)\(Endpoint.cardProviders.rawValue)"
        request(url, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let data = String(data: jsonData, encoding: .utf8)?.data(using: .utf8)
                    let decoder = JSONDecoder()
                    let cardProviderResponse = try decoder.decode(CardProviderResponse.self, from: data!)
                    successHandler(cardProviderResponse.data)
                } catch let error {
                    errorHandler(error)
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }

    /// Create a card token
    ///
    /// - parameter card: Card used to create the token
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter errorHandler: Callback to execute if the request failed
    public func createCardToken(card: CardRequest,
                                successHandler: @escaping (CardTokenResponse) -> Void,
                                errorHandler: @escaping (ErrorResponse) -> Void) {
        let url = "\(environment.rawValue)\(Endpoint.createCardToken.rawValue)"
        request(url, method: .post, parameters: card.toDictionary(),
                          encoding: JSONEncoding.default, headers: headers)
            .validate().responseJSON { response in
            let decoder = JSONDecoder()
            switch response.result {
            case .success:
                do {
                    let cardTokenResponse = try decoder.decode(CardTokenResponse.self, from: response.data!)
                    successHandler(cardTokenResponse)
                } catch let error {
                    print(error)
                }
            case .failure:
                do {
                    let cardTokenError = try decoder.decode(ErrorResponse.self, from: response.data!)
                    errorHandler(cardTokenError)
                } catch let error {
                    print(error)
                }
            }
        }
    }

    /// Create a card token with Apple Pay
    ///
    /// - parameter paymentData: Apple Pay payment data used to create a card token
    /// - parameter successHandler: Callback to execute if the request is successful
    /// - parameter erroHandler: Callback to execute if the request failed
    public func createApplePayToken(paymentData: Data,
                                    successHandler: @escaping (ApplePayToken) -> Void,
                                    errorHandler: @escaping (ErrorResponse) -> Void) {
        let url = "\(environment.rawValue)\(Endpoint.createApplePayToken.rawValue)"
        // swiftlint:disable:next force_try
        var urlRequest = try! URLRequest(url: URL(string: url)!, method: HTTPMethod.post, headers: headers)
        urlRequest.httpBody = paymentData
        request(urlRequest).validate().responseJSON { response in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            switch response.result {
            case .success:
                do {
                    let applePayToken = try decoder.decode(ApplePayToken.self, from: response.data!)
                    successHandler(applePayToken)
                } catch let error {
                    print(error)
                }
            case .failure:
                do {
                    let applePayTokenError = try decoder.decode(ErrorResponse.self, from: response.data!)
                    errorHandler(applePayTokenError)
                } catch let error {
                    print(error)
                }
            }
        }
    }

}
