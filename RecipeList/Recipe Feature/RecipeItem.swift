//
//  RecipeItem.swift
//  RecipeList
//
//  Created by sam hastings on 08/11/2024.
//

import Foundation

public struct RecipeItem: Equatable {
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?
}
