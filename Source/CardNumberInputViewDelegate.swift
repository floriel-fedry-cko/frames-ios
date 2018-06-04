import Foundation

/// Method that you can use to handle the card number changes.
public protocol CardNumberInputViewDelegate: class {

    /// Called when the card number changed.
    ///
    /// - parameter cardType: Type of the card number.
    func onChange(cardType: CardType?)

    /// Tells the delegate that editing stopped for the specified text field.
    ///
    /// - parameter _: Textfield
    func textFieldDidEndEditing(_ textField: UITextField)
}
