import UIKit

/// Standard Input View containing a label and an input field.
@IBDesignable public class StandardInputView: UIView, UIGestureRecognizerDelegate {

    // MARK: - Properties

    /// Label
    public let label = UILabel()
    /// Text Field
    public let textField = UITextField()
    /// Error label
    public let errorLabel = UILabel()
    let tapGesture = UITapGestureRecognizer()
    // height constraint
    var heightConstraint: NSLayoutConstraint!
    let stackview = UIStackView()
    let contentView = UIView()

    @IBInspectable var text: String = "Label" {
        didSet {
            label.text = text
        }
    }
    @IBInspectable var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        self.tapGesture.addTarget(self, action: #selector(StandardInputView.onTapView))

        #if TARGET_INTERFACE_BUILDER
        if self.placeholder.isEmpty {
            self.placeholder = "placeholder"
        }
        #endif

        // add gesture recognizer
        self.addGestureRecognizer(self.tapGesture)

        // add values
        textField.keyboardType = .default
        textField.textContentType = .name
        textField.textAlignment = .right
        stackview.axis = .vertical
        stackview.backgroundColor = .clear
        stackview.spacing = 2
        // inspectable
        label.text = text
        textField.placeholder = placeholder
        self.backgroundColor = .black

        // add to view
        contentView.addSubview(label)
        contentView.addSubview(textField)
        stackview.addArrangedSubview(contentView)
        stackview.addArrangedSubview(errorLabel)

        errorLabel.isHidden = true
        errorLabel.textColor = .red

        self.addSubview(stackview)

        addConstraints()
    }

    @objc func onTapView() {
        textField.becomeFirstResponder()
    }

    private func addConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackview.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        stackview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        heightConstraint = stackview.heightAnchor.constraint(equalToConstant: 48)
        heightConstraint.isActive = true

        errorLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: stackview.leadingAnchor, constant: 16).isActive = true

        contentView.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true

    }

    func set(label: String, backgroundColor: UIColor) {
        self.label.text = NSLocalizedString(label, bundle: Bundle(for: StandardInputView.self), comment: "")
        self.backgroundColor = backgroundColor
    }

    // MARK: - Methods

    public func showError(message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
        self.heightConstraint.constant = 48 + 32
        self.layoutIfNeeded()
    }

    public func hideError() {
        errorLabel.isHidden = true
        self.heightConstraint.constant = 48
        self.layoutIfNeeded()
    }
}
