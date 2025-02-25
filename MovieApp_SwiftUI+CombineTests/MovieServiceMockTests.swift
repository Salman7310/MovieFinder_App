//
//  MovieServiceMockTests.swift
//  MovieApp_SwiftUI+CombineTests
//
//  Created by Salman_Macbook on 24/02/25.
//

import XCTest
@testable import MovieApp_SwiftUI_Combine

final class MovieServiceMockTests: XCTestCase {
    
    var movieModel: MovieResponse?
    
    override func setUp() {
        super.setUp()
        
        do {
            try fetchMock()
        } catch {
            XCTFail("\(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        movieModel = nil
    }
    
    private func loadMockResponse() throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "movie_response", ofType: "json") else {
            XCTFail("Missing mock response file")
            return Data()
        }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func fetchMock() throws {
        let mockData = try loadMockResponse()
        let decoder = JSONDecoder()
        movieModel = try decoder.decode(MovieResponse.self, from: mockData)
        
        // Assert
        XCTAssertNotNil(movieModel, "Movies should not be empty")
    }
    
    func testFetchMoviesSuccess() throws {
        let movies = movieModel?.Search
        
        // Assert
        XCTAssertNotNil(movies, "Movies array should not be empty")
        
        let firstMovie = movies?[0]
        XCTAssertEqual(firstMovie?.title, "Batman: The Killing Joke", "Movie title should match")
        XCTAssertEqual(firstMovie?.year, "2016", "Movie year should match")
        XCTAssertEqual(firstMovie?.imdbId, "tt4853102", "Movie IMDb ID should match")
        XCTAssertEqual(firstMovie?.poster, URL(string: "https://m.media-amazon.com/images/M/MV5BMzJiZTJmNGItYTUwNy00ZWE2LWJlMTgtZjJkNzY1OTRiNTZlXkEyXkFqcGc@._V1_SX300.jpg"), "Movie poster URL should match")
    }
    
}
