//
//  MovieApp_SwiftUI_CombineTests.swift
//  MovieApp_SwiftUI+CombineTests
//
//  Created by Salman_Macbook on 24/02/25.
//

import XCTest
import Combine

final class MovieApp_SwiftUI_CombineTests: XCTestCase {
    
    private var cancellable: Set<AnyCancellable> = []
    
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
            }.store(in: &cancellable)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}
