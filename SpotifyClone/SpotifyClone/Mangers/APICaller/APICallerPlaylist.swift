//
//  APICallerPlaylist.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 30/06/2022.
//

import Foundation

extension APICaller {
    //MARK: - getFeaturedPlaylists
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/featured-playlists?limit=2"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch  {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
}
