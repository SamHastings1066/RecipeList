//
//  RecipeListView.swift
//  RecipeApp
//
//  Created by sam hastings on 18/11/2024.
//

import SwiftUI
import RecipeList

struct RecipeListView: View {
    let title: String
    let recipeList: [RecipeItem]
    
    var body: some View {
        
        Text(title)
            .font(.title)
            .fontWeight(.medium)
        
        List(recipeList, id: \.uuid) { recipe in
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
        .listStyle(.plain)
        
    }
}

#Preview {
    let recipeList: [RecipeItem] = [
        RecipeItem (
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        ),
        RecipeItem (
            cuisine: "British",
            name: "Apple & Blackberry Crumble",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
            sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        ),
    ]

    RecipeListView(title: "Recipes", recipeList: recipeList)
        
        
    
}
