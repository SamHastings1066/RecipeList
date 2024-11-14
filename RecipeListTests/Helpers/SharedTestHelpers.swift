//
//  SharedTestHelpers.swift
//  RecipeList
//
//  Created by sam hastings on 14/11/2024.
//

import Foundation

func anyUrl() -> URL {
    URL(string: "http://any-url.com")!
}

func httpResponse(code: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: anyUrl(), statusCode: code, httpVersion: nil, headerFields: nil)!
}

func anyError() -> Error {
    AnyError()
}

private struct AnyError: Error {}
