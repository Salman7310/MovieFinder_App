//
//  ContentViewTests.swift
//  MovieApp_SwiftUI+CombineTests
//
//  Created by Salman_Macbook on 24/02/25.
//

import XCTest
import CoreData
import Combine
@testable import MovieApp_SwiftUI_Combine

final class ContentViewTests: XCTestCase {
    
    var movieModel: MovieResponse?
    var context: NSManagedObjectContext!
    var contentView: ContentView!
    var cancellables = Set<AnyCancellable>()
    var receivedValues = [String]()
    
    
    override func setUp() {
        super.setUp()
        
        do {
            try fetchMock()
            try testFetchMovies()
        } catch {
            XCTFail("\(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        movieModel = nil
        context = nil
        //httpClient = nil
        contentView = nil
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
    
    func testFetchMovies() throws {
        
        let httpClient = HTTPClient()
        let expectation = XCTestExpectation(description: "Received movies")
        
        httpClient.fetchMovie(search: "Batman")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request failed with error \(error)")
                }
            } receiveValue: { movies in
                XCTAssertTrue(movies.count > 0)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}
