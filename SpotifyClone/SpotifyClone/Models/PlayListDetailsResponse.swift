//
//  PlayListDetailsResponse.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 04/07/2022.
//

import Foundation

struct PlayListDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse : Codable {
    let items: [PlayListItem]
}

struct PlayListItem: Codable {
    let track: AudioTrack
}
