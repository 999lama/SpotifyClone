//
//  AuthViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let perfs = WKWebpagePreferences()
        perfs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = perfs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var competionHandler: ((Bool) -> Void)? //onec user sucessfuly sign in

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManger.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange code that spotify give us for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"}) else {
            return
        }
        print("Code: \(code)")
        
    }

}
