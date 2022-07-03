//
//  APICallerRecommenation.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 30/06/2022.
//

import Foundation

extension APICaller {
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommenationResponse, Error>) -> Void)) {
           let seeds = genres.joined(separator: ",")
           createRequest(
               with: URL(string: Constant.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
               type: .GET
           ) { request in
           let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.faileedToGetData))
                       return
                   }

                   do {

                       let result = try JSONDecoder().decode(RecommenationResponse.self, from: data)
                       completion(.success(result))
                   }
                   catch {
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }

       public func gerRecommendedGenres(completion: @escaping ((Result<RecmmendedGenerasResponse, Error>) -> Void)) {
           createRequest(
               with: URL(string: Constant.baseAPIURL + "/recommendations/available-genre-seeds"),
               type: .GET
           ) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.faileedToGetData))
                       return
                   }

                   do {
                       let result = try JSONDecoder().decode(RecmmendedGenerasResponse.self, from: data)
                       completion(.success(result))
                   }
                   catch {
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
    
}
