//
//  RecipeListViewModel.swift
//  RecipeApp
//
//  Created by sam hastings on 19/11/2024.
//

import Foundation
import RecipeList

public class RecipeListViewModel {
    
    public var isLoading = true
    
    public init() {
        
    }
    
    public func loadRecipes() async -> [RecipeItem] {
        isLoading = true
        isLoading = false
        return []
    }
}
