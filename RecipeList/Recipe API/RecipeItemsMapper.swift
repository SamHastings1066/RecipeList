//
//  RecipeItemsMapper.swift
//  RecipeList
//
//  Created by sam hastings on 13/11/2024.
//

import Foundation

internal final class RecipeItemsMapper{
    
    private struct Root: Decodable {
        let recipes: [RemoteRecipeItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteRecipeItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteRecipeLoader.Error.invalidJson
        }
        return root.recipes
    }
}
