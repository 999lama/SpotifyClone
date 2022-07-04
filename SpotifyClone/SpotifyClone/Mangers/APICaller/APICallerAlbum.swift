//
//  APICallerAlbum.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 03/07/2022.
//

import Foundation
import UIKit
extension APICaller {
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch  {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
