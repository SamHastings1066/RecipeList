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
    
    func test_load_deliversRecipeItemsOn200HTTPResponseWithJSONItems() async {
        let item1 = makeRecipeItem(
            cuisine: "Malaysian",
            name: "Apam Balik",
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
        )
        
        let item2 = makeRecipeItem(
            cuisine: "British",
            name: "Apple & Blackberry Crumble",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
            youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        )
        
        let items = [item1.model, item2.model]
        let jsonData = makeRecipesJSONData([item1.json, item2.json])
        let validResponse = (jsonData, httpResponse(code: 200))
        let (sut, _) = makeSUT(result: .success(validResponse))
        do {
            let recipeItems = try await sut.load()
            XCTAssertEqual(recipeItems, items)
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
    
    private func makeRecipeItem( cuisine: String, name: String, photoUrlLarge: String? = nil, photoUrlSmall: String? = nil, sourceUrl: String? = nil, uuid: String, youtubeUrl: String? = nil) -> (model: RecipeItem, json: [String: Any]) {
        
        let item = RecipeItem (
            cuisine: cuisine,
            name: name,
            photoUrlLarge: photoUrlLarge,
            photoUrlSmall: photoUrlSmall,
            uuid: uuid,
            sourceUrl: sourceUrl,
            youtubeUrl: youtubeUrl
        )
        let json =  [
            "cuisine": cuisine,
            "name": name,
            "photo_url_large": photoUrlLarge,
            "photo_url_small": photoUrlSmall,
            "uuid": uuid,
            "source_url": sourceUrl,
            "youtube_url": youtubeUrl
        ].compactMapValues { $0 }
        return (item, json)
    }
    
    private func makeRecipesJSONData(_ recipes: [[String: Any]]) -> Data {
        let json = [ "recipes" : recipes ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

private func httpResponse(code: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: anyUrl(), statusCode: code, httpVersion: nil, headerFields: nil)!
}

private func anyError() -> Error {
    AnyError()
}

private struct AnyError: Error {}
