//
//  URLSessionHTTPClient.swift
//  RecipeList
//
//  Created by sam hastings on 14/11/2024.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: HTTPSession
    
    public init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }
    
    public func get(from url: URL) async throws -> (Data, URLResponse) {
        try await session.data(from: url)
    }
}

public protocol HTTPSession {
    func data(from: URL) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {}
