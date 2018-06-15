class SchemeIconsStackView: UIStackView {

    var shouldSetupConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func addSchemeIcon(scheme: CardScheme) {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let baseBundle = Bundle(for: SchemeIconsStackView.self)
        let path = baseBundle.path(forResource: "CheckoutSdkIos", ofType: "bundle")
        let bundle = path == nil ? baseBundle : Bundle(path: path!)
        let image = UIImage(named: "schemes/icon-\(scheme.rawValue)", in: bundle,
                            compatibleWith: nil)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    public func setIcons(schemes: [CardScheme]) {
        schemes.forEach { scheme in
            addSchemeIcon(scheme: scheme)
        }
        addFillerView()
    }

    private func addFillerView() {
        let fillerView = UIView()
        fillerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fillerView.backgroundColor = .clear
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(fillerView)
    }
}
