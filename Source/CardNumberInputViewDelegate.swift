import Foundation

public protocol CardNumberInputViewDelegate: class, UITextFieldDelegate {
    func onChange(cardType: CardType?)
}
