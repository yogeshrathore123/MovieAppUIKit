//
//  HTTPClient.swift
//  MovieAppUIKit
//
//  Created by Yogesh Rathore on 17/06/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
}

class HTTPClient {
    
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        
        // Here Pass your OMDB API Key
        let OMDB_API_KEY = ""
        guard let encodedSearch = search.urlEncoded,
                let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=\(OMDB_API_KEY)")
        else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
