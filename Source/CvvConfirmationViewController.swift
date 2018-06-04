import Foundation

public class CvvConfirmationViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onConfirmCvv))
    }
    
    // MARK: - Methods
    
    @objc public func onConfirmCvv() {}
    
    @objc public func onCancel() {}
}
