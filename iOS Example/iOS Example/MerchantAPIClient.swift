import Foundation
import CheckoutSdkIos
import Alamofire

class MerchantAPIClient {

    let baseUrl = "https://ugly-cougar-81.localtunnel.me/"

    func get(customer: String, successHandler: @escaping (Customer) -> Void) {
        let endpoint = "customer/\(customer)"
        request("\(baseUrl)\(endpoint)").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let data = String(data: jsonData, encoding: .utf8)?.data(using: .utf8)
                    let decoder = JSONDecoder()
                    let customerResponse = try decoder.decode(Customer.self, from: data!)
                    successHandler(customerResponse)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
