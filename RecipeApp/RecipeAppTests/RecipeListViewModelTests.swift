//
//  RecipeListViewModelTests.swift
//  RecipeListViewModelTests
//
//  Created by sam hastings on 19/11/2024.
//

import XCTest
import RecipeApp

final class RecipeListViewModelTests: XCTestCase {


    func test_init_createsViewModelInLoadingState() throws {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.isLoading)
        
    }

    // MARK: - Helper
    
    private func makeSUT() -> RecipeListViewModel {
        return RecipeListViewModel()
    }

}
