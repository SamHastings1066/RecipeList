//
//  RecipeListEndToEndTests.swift
//  RecipeListEndToEndTests
//
//  Created by sam hastings on 14/11/2024.
//

import XCTest
import RecipeList

final class RecipeListEndToEndTests: XCTestCase {

    func test_endToEndAllRecipesServerGETRecipeResult_matchesFixedTestAccountData() async throws {
        let allRecipesServerUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let client = URLSessionHTTPClient()
        let loader = RemoteRecipeLoader(url: allRecipesServerUrl, client: client)
        
        let receivedRecipeItems = try await loader.load()
        
        XCTAssertEqual(receivedRecipeItems.count, 63, "Expected 63 recipes in from the all-recipes Server.")
        
        XCTAssertEqual(receivedRecipeItems[0], expectedRecipe(at: 0))
        XCTAssertEqual(receivedRecipeItems[1], expectedRecipe(at: 1))
        XCTAssertEqual(receivedRecipeItems[2], expectedRecipe(at: 2))
    }
    
    func test_endToEndEmptyDataServerGETRecipeResult_returnsEmptyListOfRecipeItems() async throws {
        let emptyRecipesServerUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        let client = URLSessionHTTPClient()
        let loader = RemoteRecipeLoader(url: emptyRecipesServerUrl, client: client)
        
        let receivedRecipeItems = try await loader.load()
        
        XCTAssertEqual(receivedRecipeItems, [], "Expected empty recipes list from the empty-recipes Server.")
    }
    
    func test_endToEndMalformedDataServerGETRecipeResult_throwsInvalidJsonError() async {
        let malformedRecipesServerUrl = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        let client = URLSessionHTTPClient()
        let loader = RemoteRecipeLoader(url: malformedRecipesServerUrl, client: client)
        
        do {
            let _ = try await loader.load()
            XCTFail("Expected error to be thrown.")
        } catch {
            XCTAssertEqual(error as! RemoteRecipeLoader.Error, RemoteRecipeLoader.Error.invalidJson)
        }
    }
    
    // MARK: - Helpers
    
    private func expectedRecipe(at index: Int) -> RecipeItem {
        RecipeItem(
            cuisine: cuisine(at: index),
            name: name(at: index),
            photoUrlLarge: photoUrlLarge(at: index),
            photoUrlSmall: photoUrlSmall(at: index),
            uuid: uuid(at: index),
            sourceUrl: sourceUrl(at: index),
            youtubeUrl: youtubeUrl(at: index)
        )
    }
    
    private func cuisine(at index: Int) -> String {
        return [
            "Malaysian",
            "British",
            "British"
        ][index]
    }
    
    private func name(at index: Int) -> String {
        return [
            "Apam Balik",
            "Apple & Blackberry Crumble",
            "Apple Frangipan Tart"
        ][index]
    }
    
    private func photoUrlLarge(at index: Int) -> String? {
        return [
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg"
        ][index]
    }
    
    private func photoUrlSmall(at index: Int) -> String? {
        return [
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg"
        ][index]
    }
    
    private func uuid(at index: Int) -> String {
        return [
            "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "599344f4-3c5c-4cca-b914-2210e3b3312f",
            "74f6d4eb-da50-4901-94d1-deae2d8af1d1"
        ][index]
    }
    
    private func sourceUrl(at index: Int) -> String? {
        return [
            "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            nil
        ][index]
    }
    
    private func youtubeUrl(at index: Int) -> String? {
        return [
            "https://www.youtube.com/watch?v=6R8ffRRJcrg",
            "https://www.youtube.com/watch?v=4vhcOwVBDO4",
            "https://www.youtube.com/watch?v=rp8Slv4INLk"
        ][index]
    }

}
