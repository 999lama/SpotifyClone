//
//  SettingsModel.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 24/06/2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
