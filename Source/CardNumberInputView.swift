import UIKit

@IBDesignable public class CardNumberInputView: StandardInputView, UITextFieldDelegate {

    var cardsUtils: CardUtils?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        #if !TARGET_INTERFACE_BUILDER
        cardsUtils = CardUtils()
        #endif
        self.textField?.keyboardType = .default
        self.textField?.textContentType = .creditCardNumber
        self.textField?.delegate = self
    }

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
}
