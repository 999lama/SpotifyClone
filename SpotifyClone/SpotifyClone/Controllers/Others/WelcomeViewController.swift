//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - UI Elments
    private let singInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    
    //MARK: - Properties
    //TODO: Add view property here
    
    //MARK: - Life Cycle Methods
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
    
    
    //MARK: - @objc action methods
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
    
    //MARK: - UI Helpers
    private func handleuserSignIn(sucess: Bool) {
        // Log user in or yall at them for error
        guard sucess else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when sign In", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let mainAppTabVC = TabBarViewController()
        mainAppTabVC.modalPresentationStyle = .fullScreen
        present(mainAppTabVC, animated: true)
    }
}
