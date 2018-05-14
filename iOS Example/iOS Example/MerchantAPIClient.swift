import Foundation
import CheckoutSdkIos

class MerchantAPIClient {

    let baseUrl = "http://localhost:1212/"

    func get(customer: String, successHandler: @escaping ([Customer]) -> Void) {
        let endpoint = "customer/\(customer)"
//        request(url: "\(baseUrl)\(endpoint)").validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: value)
//                    let data = String(data: jsonData, encoding: .utf8)?.data(using: .utf8)
//                    let decoder = JSONDecoder()
//                    let customerResponse = try decoder.decode(Customer.self, from: data!)
//                    successHandler(customerResponse.data)
//                } catch let error {
//                    print(error)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
