//
//  AuthManger.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import Foundation

final class AuthManger {
    
    static let shared = AuthManger()
    
    private init() {}
    
    var isSingedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var sholdRefreshToken: Bool? {
        return false
    }
}
