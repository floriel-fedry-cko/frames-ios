import Foundation

/// Method that you can use to handle the card number changes.
public protocol CardNumberInputViewDelegate: class, UITextFieldDelegate {

    /// Called when the card number changed.
    ///
    /// - parameter cardType: Type of the card number.
    func onChange(cardType: CardType?)
}
