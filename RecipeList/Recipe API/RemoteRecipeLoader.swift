//
//  RemoteRecipeLoader.swift
//  RecipeList
//
//  Created by sam hastings on 08/11/2024.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, URLResponse)
}

public final class RemoteRecipeLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() async throws {
        guard let (data, response) = try? await client.get(from: url) else {
            throw Error.connectivity
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Error.invalidData
        }
    }
}
