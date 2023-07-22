//
//  UrlsResponse.swift
//  Image Feed
//
//  Created by Павел Врухин on 22.07.2023.
//

import Foundation

struct Urls {
    let thumb: String?
    let regular: String?
    
    private enum CodingKeys: String, CodingKey {
        case thumb
        case regular
    }
}
