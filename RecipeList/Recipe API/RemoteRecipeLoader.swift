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
        case invalidResponse
        case invalidJson
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() async throws -> [RecipeItem] {
        guard let (data, response) = try? await client.get(from: url) else {
            throw Error.connectivity
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Error.invalidResponse
        }
        
            
        return try RemoteRecipeLoader.map(data, from: response)

    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RecipeItem] {
        let items = try RecipeItemsMapper.map(data, from: response)
        return items.toModels()
    }
}

private extension Array where Element == RemoteRecipeItem {
    func toModels() -> [RecipeItem] {
        return map{ RecipeItem(cuisine: $0.cuisine, name: $0.name, photoUrlLarge: $0.photo_url_large, photoUrlSmall: $0.photo_url_small, uuid: $0.uuid, sourceUrl: $0.source_url, youtubeUrl: $0.youtube_url) }
    }
}
