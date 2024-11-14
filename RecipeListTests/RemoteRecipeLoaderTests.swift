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
    
    func test_load_requestsDataFromURL() async {
        let url = URL(string: "http://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        _ = try? await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() async {
        let url = URL(string: "http://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        _ = try? await sut.load()
        _ = try? await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() async {
        
        let (sut, _) = makeSUT(result: .failure(anyError()))
        
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(RemoteRecipeLoader.Error.connectivity), got success")
        } catch {
            XCTAssertEqual(error as? RemoteRecipeLoader.Error, RemoteRecipeLoader.Error.connectivity)
        }
        
    }
    
    func test_load_deliversInvalidResponseErrorOnNon200Response() async {
        
        let non200StatusCodes = [199, 201, 300, 400, 500]
        let dummyData = Data()
        
        for code in non200StatusCodes {
            let non200Response = (dummyData, httpResponse(code: code))
            let (sut, _) = makeSUT(result: .success(non200Response))
            do {
                _ = try await sut.load()
                XCTFail("Expected error: \(RemoteRecipeLoader.Error.invalidResponse), got success")
            } catch {
                XCTAssertEqual(error as? RemoteRecipeLoader.Error, RemoteRecipeLoader.Error.invalidResponse)
            }
        }
        
    }
    
    func test_load_deliversInvalidJsonErrorOn200ResponseWithInvalidJSON() async {
        let invalidData = Data("invalid-json".utf8)
        
        let (sut, _) = makeSUT(result: .success((invalidData, httpResponse(code: 200))))
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(RemoteRecipeLoader.Error.invalidJson), got success")
        } catch {
            XCTAssertEqual(error as? RemoteRecipeLoader.Error, RemoteRecipeLoader.Error.invalidJson)
        }
    }
    
    func test_load_deliversNoRecipeItemsOn200HTTPResponseWithEmptyJSONList() async {
        let emptyListJSONData = makeRecipesJSONData([])
        let (sut, _) = makeSUT(result: .success((emptyListJSONData, httpResponse(code: 200))))
        do {
            let recipeItems = try await sut.load()
            XCTAssertEqual(recipeItems, [])
        } catch {
            XCTFail("Expected success, got error: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Helpers

    private func makeSUT(url: URL = anyUrl(), result: Result<(Data, URLResponse), Error> = .failure(anyError()) ) -> (sut: RemoteRecipeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteRecipeLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private(set) var requestedURLs = [URL]()
        var result: Result<(Data, URLResponse), Error>
        
        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }
        
        func get(from url: URL) async throws -> (Data, URLResponse) {
            requestedURLs.append(url)
            return try result.get()
        }
    }
    
    private func makeRecipesJSONData(_ recipes: [[String: Any]]) -> Data {
        let json = [ "recipes" : recipes ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

private func anyUrl() -> URL {
    URL(string: "http://any-url.com")!
}

private func httpResponse(code: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: anyUrl(), statusCode: code, httpVersion: nil, headerFields: nil)!
}

private func anyError() -> Error {
    AnyError()
}

private struct AnyError: Error {}
