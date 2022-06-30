//
//  APICaller.swift
//  Spotify
//
//  Created by Lama Albadri on 22/06/2022.
//

import Foundation

final class APICaller {
    
    //MARK: - shared propety
    static let shared = APICaller()
    
    //MARK: - init
    private init() {}
    
    //MARK: - Constants
    struct Constant {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    //MARK: - APIError
    enum APIError: Error {
        case faileedToGetData
    }
    //MARK: - HTTPMethod
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    
    //MARK: - createRequest
    func createRequest(with url: URL?,
                       type: HTTPMethod,
                       completion: @escaping (URLRequest)-> Void) {
        AuthManger.shared.withVaildToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }

    
  
}

