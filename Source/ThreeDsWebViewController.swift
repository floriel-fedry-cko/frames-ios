import UIKit
import WebKit

public class ThreeDsWebViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Properties

    var webView: WKWebView!
    let successUrl: String
    let failUrl: String

    /// Delegate
    public weak var delegate: ThreeDsWebViewControllerDelegate?

    /// Url
    public var url: String?

    // MARK: - Initialization

    public init(successUrl: String, failUrl: String) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        successUrl = ""
        failUrl = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        successUrl = ""
        failUrl = ""
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    /// Called after the controller's view is loaded into memory.
    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = url else { return }
        let myURL = URL(string: authUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.load(myRequest)
    }

    // MARK: - WKNavigationDelegate

    /// Called when a web view receives a server redirect.
    public func webView(_ webView: WKWebView,
                        didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // stop the redirection
        webView.stopLoading()
        // get the redirection absoluteUrl
        let absoluteUrl = webView.url!
        // get URL conforming to RFC 1808 without the query
        let url = "\(absoluteUrl.scheme ?? "https")://\(absoluteUrl.host ?? "localhost")\(absoluteUrl.path)/"

        if url == successUrl {
            // success url, dismissing the page with the payment token
            self.dismiss(animated: true) {
                self.delegate?.onSuccess3D()
            }
        } else {
            // fail url, dismissing the page
            self.dismiss(animated: true) {
                self.delegate?.onFailure3D()
            }
        }
    }

}
