//
//  HTTPClient.swift
//  RecipeList
//
//  Created by sam hastings on 14/11/2024.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, URLResponse)
}
