//
//  RemoteRecipeLoaderTests.swift
//  RecipeListTests
//
//  Created by sam hastings on 08/11/2024.
//

import XCTest

class RemoteRecipeLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
    
}

final class RemoteRecipeLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "http://a-given.com")!
        let client = HTTPClientSpy()
        let _ = RemoteRecipeLoader(client: client, url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given.com")!
        let client = HTTPClientSpy()
        let sut = RemoteRecipeLoader(client: client, url: url)
        
        
        sut.load()
        
        XCTAssertEqual(url, client.requestedURL)
    }

}
