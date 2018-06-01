import UIKit

/// Cvv Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CvvInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    var cardType: CardType?
    /// Text field delegate
    public weak var delegate: UITextFieldDelegate?

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
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
        self.textField.keyboardType = .numberPad
        self.textField.textContentType = nil
        self.textField.delegate = self
    }

    // MARK: - UITextFieldDelegate

    /// Asks the delegate if the specified text should be changed.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        guard let cardType = self.cardType else { return true }
        let cvv = "\(textField.text!)\(string)"
        guard cvv.count <= cardType.validCvvLengths.last! else {
            return false
        }
        return true
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
    }
}
