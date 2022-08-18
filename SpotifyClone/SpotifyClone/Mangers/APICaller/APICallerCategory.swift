//
//  APICallerCategory.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 18/08/2022.
//

import Foundation

extension APICaller {
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void ) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/categories?linit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self,
                                                          from: data)
                    completion(.success(result.categories.items))
                    print(result.categories.items )
                } catch  {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    
    public func getCategoriesPlayList(category: Category ,completion: @escaping (Result<[Playlist], Error>) -> Void ) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    let playlists = json.playlists.items
                    print(playlists)
                    completion(.success(playlists))
                    print(json)
                } catch  {
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
}
