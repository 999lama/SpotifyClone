//
//  Playlist.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}

