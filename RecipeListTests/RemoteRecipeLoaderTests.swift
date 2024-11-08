//
//  RemoteRecipeLoaderTests.swift
//  RecipeListTests
//
//  Created by sam hastings on 08/11/2024.
//

import XCTest
import RecipeList

final class RemoteRecipeLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(url, client.requestedURL)
    }
    
    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-given.com")!) -> (sut: RemoteRecipeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRecipeLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
        
    }
}
