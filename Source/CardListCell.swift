import UIKit

public class CardListCell: UITableViewCell {

    // MARK: Properties

    public let stackView = UIStackView()
    public let schemeImageView = UIImageView()
    public let selectedImageView = UIImageView()
    public let cardInfoLabel = UILabel()
    public let nameLabel = UILabel()

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // configure the view for the selected state
    }

    public func setSchemeIcon(scheme: CardScheme) {
        let image = UIImage(named: "\(scheme.rawValue)-icon")
        schemeImageView.image = image
    }

    private func setup() {
        stackView.addArrangedSubview(cardInfoLabel)
        stackView.addArrangedSubview(nameLabel)
        self.addSubview(stackView)
        self.addSubview(schemeImageView)
        self.addSubview(selectedImageView)
        stackView.axis = .vertical
        stackView.spacing = 16
        selectedImageView.image = #imageLiteral(resourceName: "keyboard-next")
        addConstraints()
    }

    private func addConstraints() {
        self.heightAnchor.constraint(equalToConstant: 90).isActive = true
        // constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        schemeImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        // setup
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        schemeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        schemeImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        schemeImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        layoutMarginsGuide.trailingAnchor.constraint(equalTo: selectedImageView.trailingAnchor, constant: 8)
            .isActive = true
        selectedImageView.leadingAnchor.constraint(equalTo: schemeImageView.trailingAnchor, constant: 8).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        selectedImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        selectedImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
    }
}
