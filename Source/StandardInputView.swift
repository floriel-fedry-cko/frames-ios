import UIKit

/// Standard Input View containing a label and an input field.
@IBDesignable public class StandardInputView: UIView, UIGestureRecognizerDelegate {

    /// Label
    public let label = UILabel()
    /// Text Field
    public let textField = UITextField()
    let tapGesture = UITapGestureRecognizer()

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
        // inspectable
        label.text = text
        textField.placeholder = placeholder

        // add to view
        self.addSubview(label)
        self.addSubview(textField)

        addConstraints()
    }

    @objc func onTapView() {
        textField.becomeFirstResponder()
    }

    private func addConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
    }

    func set(label: String, backgroundColor: UIColor) {
        self.label.text = NSLocalizedString(label, bundle: Bundle(for: StandardInputView.self), comment: "")
        self.backgroundColor = backgroundColor
    }
}
