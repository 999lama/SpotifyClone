//
//  AuthManger.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import Foundation

final class AuthManger {
    
    struct Constant {
        static let clientID = "3bce8700a42641dbb2f9e9be2bed73a0"
        static let clientSecret = "e67700222bfd44fa83fbcdb544d3e2ab"
    }
    
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
