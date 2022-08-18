//
//  CategoryCollectiocnViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 18/08/2022.
//

import Foundation

struct CategoryCollectiocnViewCellViewModel { 
    let title: String
    let artWorkUrl: URL?
    
    init(title: String, artWorkUrl: URL?) {
        self.title = title
        self.artWorkUrl = artWorkUrl
    }
}
