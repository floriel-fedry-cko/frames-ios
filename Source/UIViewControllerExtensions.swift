import Foundation

extension UIViewController {

    func addScrollViewContraints(scrollView: UIScrollView, contentView: UIView) -> NSLayoutConstraint {
        // Content View Constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                                                              multiplier: 1.0)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
        // Scroll View Constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.view.safeBottomAnchor)
        scrollViewBottomConstraint.isActive = true
        // return scrollView bottom anchor constraint, used to manage the keyboard
        return scrollViewBottomConstraint
    }

    @objc func scrollViewOnKeyboardWillShow(notification: NSNotification, scrollView: UIScrollView) {
        guard let activeField = UIResponder.current as? UITextField else { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets

            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            let activeTextFieldRect: CGRect? = activeField.frame
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
            if !aRect.contains(activeTextFieldOrigin!) {
                scrollView.scrollRectToVisible(activeTextFieldRect!, animated: true)
            }
        }
    }

    @objc func scrollViewOnKeyboardWillHide(notification: NSNotification, scrollView: UIScrollView) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

}
