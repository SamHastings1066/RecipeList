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
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestsDataFromURL() async throws {
        let url = URL(string: "http://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() async throws {
        let url = URL(string: "http://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        try await sut.load()
        try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliverErrorOnClientError() async {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        
        var returnedErrors = [RemoteRecipeLoader.Error]()
        do {
            try await sut.load()
        } catch {
            if let error = error as? RemoteRecipeLoader.Error {
                returnedErrors.append(error)
            }
        }
        XCTAssertEqual(returnedErrors, [.connectivity])
    }
    
    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-given.com")!) -> (sut: RemoteRecipeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRecipeLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url: URL) -> Error? {
            requestedURLs.append(url)
            return error
        }
        
        func get(from url: URL) throws {
            if let error {
                throw error
            }
            requestedURLs.append(url)
        }
    }
}
