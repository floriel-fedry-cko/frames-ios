import UIKit

/// Table View Cell adapted to display a card.
public class CardListCellName: CardListCell {

    // MARK: - Properties

    /// Name Label
    public let nameLabel = UILabel()

    // MARK: - Initialization

    /// Initializes a table cell with a style and a reuse identifier and returns it to the caller.
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(nameLabel)
        addConstraints()
    }

    private func addConstraints() {
        self.constraints.first { $0.firstAnchor == heightAnchor }?.isActive = false
        self.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }

    // MARK: - Methods

    /// Sets the selected state of the cell, optionally animating the transition between states.
    override public func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            let image = UIImage(named: "checkmarks/checkmark", in: Bundle(for: CardListCell.self),
                                compatibleWith: nil)
            selectedImageView.image = image
        } else {
            selectedImageView.image = nil
        }
    }

}
