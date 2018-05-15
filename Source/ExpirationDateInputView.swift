import UIKit

@IBDesignable public class ExpirationDateInputView: StandardInputView, ExpirationDatePickerDelegate {

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let expirationDatePicker = ExpirationDatePicker()
        expirationDatePicker.pickerDelegate = self
        self.textField?.inputView = expirationDatePicker
    }

    public func onDateChanged(month: String, year: String) {
        self.textField?.text = "\(month)/\(year)"
    }
}
