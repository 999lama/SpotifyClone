//
//  ViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit

enum BrowseSectionType {
    case newRelases // 1
    case featuredPlayList // 2
    case recommendedTracks // 3
}

class HomeViewController: UIViewController {


    //MARK: - UI Elments
    private var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ in
        return HomeViewController.createSectionLayout(section: sectionIndex)
    }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
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
        view.addSubview(spinner)
        configureCollectionView()

        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
      
    }
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
  
    
    private func fetchData() {
        // New Relasess
        // Featured playlists
        // Recommended Tracks
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .purple
        } else if indexPath.section == 1 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .blue
        }
        return cell
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group iniside horiontal
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                            heightDimension: .absolute(390)),
                                                         subitem: item, count: 3)
            let horizonatlGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                                                                      heightDimension: .absolute(390)),
                                                                   subitem: verticalGroup, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizonatlGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                                            heightDimension: .absolute(200))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
 
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                                                                      heightDimension: .absolute(400)),
                                                                   subitem: item, count: 2)
            
            let horizonatlGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                                                                      heightDimension: .absolute(400)),
                                                                   subitem: verticalGroup, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizonatlGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 2:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group iniside horiontal
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                            heightDimension: .absolute(80)),
                                                         subitem: item, count: 1)
         
            //section
            let section = NSCollectionLayoutSection(group: group)
            return section
        default:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group iniside horiontal
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                            heightDimension: .absolute(390)),
                                                         subitem: item, count: 1)
          
            //section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}
