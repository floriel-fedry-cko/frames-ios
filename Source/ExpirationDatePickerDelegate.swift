import Foundation

/// Method that you can use to manage the editing of the expiration date
public protocol ExpirationDatePickerDelegate: class {
    func onDateChanged(month: String, year: String)
}
