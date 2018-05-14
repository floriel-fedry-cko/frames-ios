import Foundation

/// Method that you can use to manage the editing of the expiration date
public protocol CardViewControllerDelegate: class {
    func onTapDone(card: CardRequest)
}
