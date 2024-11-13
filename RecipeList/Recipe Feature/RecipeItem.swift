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
    
    init(cuisine: String, name: String, photo_url_large: String?, photo_url_small: String?, uuid: String, source_url: String?, youtube_url: String?) {
        self.cuisine = cuisine
        self.name = name
        self.photo_url_large = photo_url_large
        self.photo_url_small = photo_url_small
        self.uuid = uuid
        self.source_url = source_url
        self.youtube_url = youtube_url
    }
}
