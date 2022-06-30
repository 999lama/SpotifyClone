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
    
    public func getRecommendedGeners(completion: @escaping (Result<RecmmendedGenerasResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecmmendedGenerasResponse.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch  {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    public func getRecommenations(genres: Set<String> ,completion: @escaping (Result<String,Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constant.baseAPIURL + "/recommendations?seed_genres=\(seeds)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    completion(.success(result))
                    print(result)
                } catch  {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    public func getNewReslase(completion: @escaping ((Result<NewRelasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewRelasesResponse.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch  {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
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

