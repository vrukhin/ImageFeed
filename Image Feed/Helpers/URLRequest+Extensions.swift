//
//  URLRequest+Extensions.swift
//  Image Feed
//
//  Created by Павел Врухин on 29.06.2023.
//

import Foundation

fileprivate let DefaultBaseUrl = URL(string: "https://unsplash.com")!

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseUrl
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
