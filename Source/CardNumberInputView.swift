import UIKit

/// Card Number Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CardNumberInputView: StandardInputView, UITextFieldDelegate {

    var cardsUtils: CardUtils?
    /// Text field delegate
    public weak var delegate: UITextFieldDelegate?

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

    private func setup() {
        #if !TARGET_INTERFACE_BUILDER
        cardsUtils = CardUtils()
        #endif
        self.textField.keyboardType = .default
        self.textField.textContentType = .creditCardNumber
        self.textField.delegate = self
    }

    /// Asks the delegate if the specified text should be changed.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        // Card Number Formatting
        let cardNumber = cardsUtils!.standardize(cardNumber: "\(textField.text!)\(string)")
            if string.isEmpty { return true }
            let cardType = cardsUtils!.getTypeOf(cardNumber: cardNumber)
            guard let cardTypeUnwrap = cardType else { return false }
            guard cardNumber.count <= cardTypeUnwrap.validLengths.last! else {
                return false
            }
            textField.text = cardsUtils!.format(cardNumber: cardNumber, cardType: cardTypeUnwrap)
        return false
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
    }
}
