//
//  RecipeLoader.swift
//  RecipeList
//
//  Created by sam hastings on 08/11/2024.
//

import Foundation

enum LoadRecipeResult {
    case success([RecipeItem])
    case error(Error)
}

protocol RecipeLoader {
    func load() async -> LoadRecipeResult
}
