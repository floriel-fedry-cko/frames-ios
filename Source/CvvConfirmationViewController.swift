import Foundation

public class CvvConfirmationViewController: UIViewController {
    // MARK: - Properties

    let contentView = UIView()
    let label = UILabel()
    let textField = UITextField()
    let underlineView = UIView()

    public weak var delegate: CvvConfirmationViewControllerDelegate?

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        navigationItem.title = "Confirm CVV"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(onCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(onConfirmCvv))
        view.backgroundColor = .groupTableViewBackground
        contentView.backgroundColor = .white
        label.text = "Enter your cvv."
        textField.placeholder = "CVV"
        underlineView.backgroundColor = UIColor.gray
        addViews()
        addConstraints()
    }

    private func addViews() {
        contentView.addSubview(label)
        contentView.addSubview(textField)
        contentView.addSubview(underlineView)
        self.view.addSubview(contentView)
    }

    private func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false

        contentView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -16).isActive = true
        contentView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 32).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 16).isActive = true

        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true

        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

        underlineView.widthAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 1).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underlineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        contentView.bottomAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 32).isActive = true
    }

    // MARK: - Methods

    @objc public func onConfirmCvv() {
        let cvv = "100"
        delegate?.onConfirm(controller: self, cvv: cvv)
    }

    @objc public func onCancel() {
        delegate?.onCancel(controller: self)
    }
}
