//
//  RemoteRecipeLoader.swift
//  RecipeList
//
//  Created by sam hastings on 08/11/2024.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteRecipeLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
