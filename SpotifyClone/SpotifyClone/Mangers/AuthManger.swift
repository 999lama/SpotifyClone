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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    static let shared = AuthManger()
    
    private init() {}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constant.clientID)&scope=\(Constant.scopes)&redirect_uri=\(Constant.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    private var refreshingToken = false
    
    var isSingedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    private var onRefreshBlocks = [((String) -> Void)]()

    private var sholdRefreshToken: Bool {
        // refresh token after couple of mins left to that token expires (refresh when 10 minutes left)
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    /// Supplies vaild token to be used with API Calls
    public func withVaildToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if sholdRefreshToken {
            // refresh
            refreshIfNeeded { [weak self] sucess in
                    if let token = self?.accessToken, sucess {
                       completion(token)
                    }
                }
            }
        else if let token = accessToken{
           completion(token)
        }
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
       // get token
        guard let url = URL(string: Constant.tokenAPIURL) else {
            return
        }
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constant.redirectURI)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // set Headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constant.clientID+":"+Constant.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = component.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch  {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
        
        
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {

        guard !refreshingToken else {
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh Token
         guard let url = URL(string: Constant.tokenAPIURL) else {
             return
         }
        
        refreshingToken =  true
         var component = URLComponents()
         component.queryItems = [
             URLQueryItem(name: "grant_type", value: "refresh_token"),
             URLQueryItem(name: "refresh_token", value: refreshToken)
         ]
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         // set Headers
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         let basicToken = Constant.clientID+":"+Constant.clientSecret
         let data = basicToken.data(using: .utf8)
         guard let base64String = data?.base64EncodedString() else {
             print("Failure to get base64")
             completion(false)
             return
         }
        /// Header for authorization
         request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
         request.httpBody = component.query?.data(using: .utf8)
         
         let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
             self?.refreshingToken = false
             guard let data = data , error == nil else {
                 completion(false)
                 return
             }
             do {
                 let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                 self?.onRefreshBlocks.forEach({$0(result.access_token) })
                 self?.onRefreshBlocks.removeAll()
                 self?.cacheToken(result: result)
                 completion(true)
             } catch  {
                 print(error.localizedDescription)
                 completion(false)
             }
         }
        
         task.resume()
        
    }
    
    private func cacheToken(result: AuthResponse) {

            UserDefaults.standard.setValue(result.access_token,
                                           forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token")
        }
        /*current time user login In + no of second expires In*/
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
}
