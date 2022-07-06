//
//  ViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit

enum BrowseSectionType {
    case newRelases(viewModel: [NewRelasesCellViewModel])// 1
    case featuredPlayList(viewModel: [FeaturedPlayListCellViewModel]) // 2
    case recommendedTracks(viewModel: [RecommendedTrackCellViewModel]) // 3
    
    var titel: String {
        switch self {
        case .newRelases:
            return "New Relaeased Albums"
        case .featuredPlayList:
            return "Featured PlayLists"
        case .recommendedTracks:
            return "Recommended"
        }
    }
}

class HomeViewController: UIViewController {


    private var sections = [BrowseSectionType]()
    private var newAlbums: [Album] = []
    private var tracks: [AudioTrack] = []
    private var playList: [Playlist] = []
    
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
        collectionView.register(NewRelaseCollectionViewCell.self, forCellWithReuseIdentifier: NewRelaseCollectionViewCell.identifer)
        collectionView.register(FeaturePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifer)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifer)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: TitleHeaderCollectionReusableView.identifer)
    }
  
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewRelasesResponse?
        var featuredPlaylist: FeaturedPlaylistResponse?
        var recommendations: RecommenationResponse?
        // New Relasess
        APICaller.shared.getNewReslase { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Featured playlists
        APICaller.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Recommended Tracks
               APICaller.shared.gerRecommendedGenres { result in
                   switch result {
                   case .success(let model):
                       let genres = model.genres
                       var seeds = Set<String>()
                       while seeds.count < 5 {
                           if let random = genres.randomElement() {
                               seeds.insert(random)
                           }
                       }

                       APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                           defer {
                               group.leave()
                           }

                           switch recommendedResult {
                           case .success(let model):
                               recommendations = model
                               print(model)
                           case .failure(let error):
                               print(error.localizedDescription)
                           }
                       }

                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }
        
        group.notify(queue: .main) {
            guard let recommenedation = recommendations?.tracks ,
                  let playList = featuredPlaylist?.playlists.items,
                  let newReleases = newReleases?.albums.items else {
                fatalError("models are null")
                return
            }
            self.configureModels(newAlbums: newReleases, tracks: recommenedation, playList: playList)
            
        }
// configure Models

    }
    
    private func configureModels(newAlbums: [Album],
                                 tracks: [AudioTrack],
                                 playList: [Playlist]) {
        
        self.newAlbums = newAlbums
        self.tracks = tracks
        self.playList = playList
        sections.append(.newRelases(viewModel: newAlbums.compactMap({ return NewRelasesCellViewModel(name: $0.name,
                                                                                                     artWorkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.name)
        })))
        sections.append(.featuredPlayList(viewModel:
            playList.compactMap({
                return FeaturedPlayListCellViewModel(name: $0.name,
                                                     artWorkUrl: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
            })))
        sections.append(.recommendedTracks(viewModel:
                                            tracks.compactMap({
            return RecommendedTrackCellViewModel.init(name: $0.name, artistName: $0.artists.first?.name ?? "-" ,
             artWorkUrl: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        self.collectionView.reloadData()
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
        let section = sections[section]
        switch section {
        case .newRelases(let viewModel):
            return viewModel.count
        case .featuredPlayList(let viewModel):
            return viewModel.count
        case .recommendedTracks(let viewModel):
            return viewModel.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = sections[indexPath.section]
        switch section {
        case .newRelases(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewRelaseCollectionViewCell.identifer, for: indexPath) as? NewRelaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configureWithViewModel(with: viewModel)
            cell.backgroundColor = .red
            return cell
        case .featuredPlayList(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifer, for: indexPath) as? FeaturePlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configureWithViewModel(with:viewModel )
            cell.backgroundColor = .blue
            return cell
        case .recommendedTracks(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifer, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)
            cell.backgroundColor = .orange
            return cell
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .recommendedTracks:
            break
        case .featuredPlayList:
            let playList = playList[indexPath.item]
            let vc = PlaylistViewController(playlist: playList)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)

        case .newRelases:
            let album = newAlbums[indexPath.item]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifer, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].titel
        header.configure(with: title)
        return header
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplmentaryViews =  [NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)]
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
            section.boundarySupplementaryItems = supplmentaryViews
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
            section.boundarySupplementaryItems = supplmentaryViews
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
            section.boundarySupplementaryItems = supplmentaryViews
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
            section.boundarySupplementaryItems = supplmentaryViews
            return section
        }
    }
}
