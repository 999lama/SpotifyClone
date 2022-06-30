//
//  ViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit

class HomeViewController: UIViewController {


    //MARK: - UI Elments
    //TODO: Add UI Elemnts here
    
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        self.view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                                                  style: .done,
                                                                                  target: self,
                                                                                action: #selector(didTapSettings))
        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getRecommendedGeners { result in
            switch result {
            case.success(let model):
                let geners = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = geners.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommenations(genres: seeds) { _ in
                    
                }
            case .failure(let error): break
            }
        }
//        APICaller.shared.getNewReslase { result in
//            switch result {
//            case .success(let model):
//                break
//            case .failure(let error):
//                break
//            }
//        }
    }
    
    //MARK: - @objc actions methods
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}

