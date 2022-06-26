//
//  AuthViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    //MARK: - UI Elments
    private let webView: WKWebView = {
        let perfs = WKWebpagePreferences()
        perfs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = perfs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    //MARK: - Properties
    public var competionHandler: ((Bool) -> Void)? //onec user sucessfuly sign in
    
    //MARK: - Life Cycle Methods
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
    
}

//MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange code that spotify give us for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"})?.value else {
            return
        }
        webView.isHidden = true
        
        print("Code: \(code)")
        AuthManger.shared.exchangeCodeForToken(code: code) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.competionHandler?(success)
            }
        }
    }
}
