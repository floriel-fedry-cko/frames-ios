import UIKit

@IBDesignable public class DetailsInputView: UIView, UIGestureRecognizerDelegate {

    var stackView: UIStackView?
    public var label: UILabel?
    public var value: UILabel?
    public var button: UIButton?

    @IBInspectable var text: String = "Label" {
        didSet {
            label?.text = text
        }
    }

    @IBInspectable var required: Bool = true

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        self.stackView = UIStackView()
        self.label = UILabel()
        self.value = UILabel()
        self.button = UIButton()
        // add values
        label!.text = text
        value?.textColor = UIColor.lightGray

        #if TARGET_INTERFACE_BUILDER
        self.button = UIButton(type: UIButtonType.contactAdd)
        value!.text = "value"
        #else
        button!.setImage(#imageLiteral(resourceName: "keyboard-next"), for: .normal)
        #endif
        // add to view
        stackView!.axis = .horizontal
        stackView!.spacing = 8
        stackView!.alignment = .fill
        stackView?.distribution = .fill
        stackView!.addArrangedSubview(label!)
        stackView!.addArrangedSubview(value!)
        stackView!.addArrangedSubview(button!)
        self.addSubview(stackView!)
        // add constraints
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        button!.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: stackView!.trailingAnchor, constant: 8).isActive = true
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        stackView!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

        value!.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button!.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button!.widthAnchor.constraint(equalToConstant: 16).isActive = true
    }

}
