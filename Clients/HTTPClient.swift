//
//  HTTPClient.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case noData
}

class HTTPClient {
    
    func fetchMovie(search: String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.urlEncoded,
              let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=564727fa")
        else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)
             /* Check values to apply breakpoints */
        
//            .breakpoint(receiveOutput: { movies in
//                movies.isEmpty
//            })
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                
                /*
                if let networkError = error as? NetworkError {
                    return Fail(error: networkError).eraseToAnyPublisher()
                } else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }*/
            }
            .eraseToAnyPublisher()
    }
}
