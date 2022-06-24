//
//  AuthManger.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import Foundation

final class AuthManger {
    
    struct Constant {
        static let clientID = "b41919e6ec654ab5a51bed4a8af12bb9"
        static let clientSecret = "4819fa1fd6fe4041a8978dd18e01b4e5"
    
    }
    
    static let shared = AuthManger()
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let string = "\(base)?response_type=code&client_id=\(Constant.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
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
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
       // get token
    }
    
    public func refreshAcessToken() {
         
    }
    
    private func cacheToken() {
        
    }
    
}
