import Foundation

extension String {
    func localized(forClass: AnyClass, comment: String = "") -> String {
        let baseBundle = Bundle(for: forClass)
        let path = baseBundle.path(forResource: "CheckoutSdkIos", ofType: "bundle")
        let bundleToUse = path == nil ? baseBundle : Bundle(path: path!)!
        return NSLocalizedString(self, bundle: bundleToUse, comment: "")
    }
}
