//
//  Artist.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import Foundation
struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
