//
//  URLSessionHTTPClientTests.swift
//  RecipeListTests
//
//  Created by sam hastings on 14/11/2024.
//

import XCTest
import RecipeList

final class URLSessionHTTPClientTests: XCTestCase {

    // next: Continue following along with the 4 ways to test drive tutorial.
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, session) = makeSUT()
        
        XCTAssertTrue(session.receivedURLs.isEmpty)
    }
    
    func test_getFromURL_performsGETRequestWithURL() async {
        let url = anyUrl()
        let (sut, session) = makeSUT()
        
        _ = try? await sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    func test_getFromURL_failsOnRequestError() async {
        let url = anyUrl()
        let anyError = anyError()
        let (sut, _) = makeSUT(result: .failure(anyError))
        
        do {
            _ = try await sut.get(from: url)
            XCTFail("Expected request to fail.")
        } catch {
            XCTAssertEqual(error as NSError, anyError as NSError)
        }
        
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() async throws {
        let validResponse = anyValidResponse()
        let (sut, _) = makeSUT(result: .success(validResponse))
        
        let (receivedData, receivedResponse) = try await sut.get(from: anyUrl())
        
        XCTAssertEqual(receivedData, validResponse.data)
        XCTAssertEqual(receivedResponse, validResponse.response)
            
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(result: Result<(Data, URLResponse), Error> = .failure(anyError())) -> (sut: HTTPClient, session: URLSessionSpy) {
        let session = URLSessionSpy(result: result)
        let sut = URLSessionHTTPClient(session: session)
        return (sut, session)
    }

    private class URLSessionSpy: HTTPSession {
        private(set) var receivedURLs = [URL]()
        var result: Result<(Data, URLResponse), Error>
        
        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }
        
        func data(from url: URL) async throws -> (Data, URLResponse) {
            receivedURLs.append(url)
            return try result.get()
        }
    
    }
}

private func anyValidResponse() -> (data: Data, response: URLResponse) {
    (Data(), httpResponse(code: 200))
}
