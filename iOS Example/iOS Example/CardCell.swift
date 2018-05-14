import UIKit

class CardCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var cardInformationLabel: UILabel!
    @IBOutlet weak var cardholderNameLabel: UILabel!
    @IBOutlet weak var schemeIconImageView: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // configure the view for the selected state
    }

    private func addConstraints() {
        cardInformationLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
