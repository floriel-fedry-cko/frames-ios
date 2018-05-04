import Foundation

/// Checkout API Environment
///
/// - live
/// - sandbox
public enum Environment: String {
    /// live environment used for production
    case live = "https://api2.checkout.com/v2/"
    /// sandbox environment used for development
    case sandbox = "https://sandbox.checkout.com/api2/v2/"
}
