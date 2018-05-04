import UIKit

@IBDesignable public class StandardInputView: UIView, UIGestureRecognizerDelegate {

    public var label: UILabel?
    public var textField: UITextField?
    public var tapGesture: UITapGestureRecognizer?

    @IBInspectable var text: String = "Label" {
        didSet {
            label?.text = text
        }
    }
    @IBInspectable var placeholder: String = "placeholder" {
        didSet {
            textField?.placeholder = placeholder
        }
    }
    @IBInspectable var required: Bool = true
    var keyboardType: UIKeyboardType = .default
    var contentType: UITextContentType = .name

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        self.label = UILabel()
        self.textField = UITextField()
        self.tapGesture = UITapGestureRecognizer()
        self.tapGesture?.addTarget(self, action: #selector(StandardInputView.onTapView))

        // add gesture recognizer
        self.addGestureRecognizer(self.tapGesture!)

        // add values
        textField!.keyboardType = keyboardType
        textField!.textContentType = contentType
        textField!.textAlignment = .right
        // inspectable
        label!.text = text
        textField!.placeholder = placeholder

        // add to view
        self.addSubview(label!)
        self.addSubview(textField!)

        // add constraints
        label!.translatesAutoresizingMaskIntoConstraints = false
        textField!.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.trailingAnchor.constraint(equalTo: textField!.trailingAnchor, constant: 8).isActive = true
        label!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label!.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        textField!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField!.leadingAnchor.constraint(equalTo: label!.trailingAnchor, constant: 8).isActive = true
    }

    @objc func onTapView() {
        textField?.becomeFirstResponder()
    }
}
