//
//  RecipeLoader.swift
//  RecipeList
//
//  Created by sam hastings on 08/11/2024.
//

import Foundation

protocol RecipeLoader {
    func load() async throws -> [RecipeItem]
}
