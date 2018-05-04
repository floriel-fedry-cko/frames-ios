import UIKit

@IBDesignable public class ExpirationDateInputView: StandardInputView, ExpirationDatePickerDelegate {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let expirationDatePicker = ExpirationDatePicker()
        expirationDatePicker.pickerDelegate = self
        self.textField?.inputView = expirationDatePicker
    }

    public func onDateChanged(month: String, year: String) {
        self.textField?.text = "\(month)/\(year)"
    }
}
