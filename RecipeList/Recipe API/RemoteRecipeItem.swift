//
//  RemoteRecipeItem.swift
//  RecipeList
//
//  Created by sam hastings on 13/11/2024.
//

import Foundation

public struct RemoteRecipeItem: Decodable {
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?
}
