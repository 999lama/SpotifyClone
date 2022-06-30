//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setViewControllers(self.confiureTabs(), animated: false)
    }
    
    private func confiureTabs() -> [UINavigationController] {
        var tabs = [UINavigationController]()
        let nav1 = self.configureNav(vc: HomeViewController(), with:  "Browse")
        let nav2 = self.configureNav(vc: SearchViewController(), with:  "Search")
        let nav3 = self.configureNav(vc: LibaryViewController(), with:  "Libary")
        tabs.append(self.configureTabBar(with: nav1, imageName: "house", title: "Browse", tag: 1))
        tabs.append(self.configureTabBar(with: nav2, imageName: "magnifyingglass", title: "Search", tag: 2))
        tabs.append(self.configureTabBar(with: nav3, imageName: "music.note.list", title: "Libary", tag: 3))
        return tabs
    }
    
    private func configureNav(vc: UIViewController, with title: String) -> UINavigationController {
        vc.title = title
        vc.navigationItem.largeTitleDisplayMode = .always
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    private func configureTabBar(with nav: UINavigationController , imageName: String, title: String, tag: Int) -> UINavigationController {
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: tag)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = .label
        return nav
    }
}
