//
//  RemoteRecipeLoaderTests.swift
//  RecipeListTests
//
//  Created by sam hastings on 08/11/2024.
//

import XCTest

class RemoteRecipeLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteRecipeLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        let _ = RemoteRecipeLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
