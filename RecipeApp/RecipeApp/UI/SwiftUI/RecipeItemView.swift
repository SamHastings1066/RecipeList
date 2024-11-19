//
//  RecipeItemView.swift
//  RecipeApp
//
//  Created by sam hastings on 19/11/2024.
//

import SwiftUI
import RecipeList

struct RecipeItemView: View {
    let recipe: RecipeItem
    var body: some View {
        HStack {
            
            Image(systemName: "fork.knife.circle")
                .resizable()
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(recipe.cuisine)
                    .font(.subheadline)
                
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let recipe = RecipeItem (
        cuisine: "British",
        name: "Apple & Blackberry Crumble",
        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
        sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
        youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
    )
    RecipeItemView(recipe: recipe)
}
