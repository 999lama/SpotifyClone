//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let singInButton: UIButton = {
      let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

       title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(singInButton)
        singInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        singInButton.frame = CGRect(x: 20,
                                    y:view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.competionHandler = { [weak self] (sucess) in
            DispatchQueue.main.async {
                self?.handleuserSignIn(sucess: sucess)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func handleuserSignIn(sucess: Bool) {
        // Log user in or yall at them for error
    }
}
