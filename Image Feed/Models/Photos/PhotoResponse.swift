//
//  PhotoResponse.swift
//  Image Feed
//
//  Created by Павел Врухин on 22.07.2023.
//

import Foundation

struct PhotoResponse: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: Dictionary<String, String>
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
    
    func convert() -> Photo {
        let size = CGSize(width: self.width, height: self.height)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let createdAt = dateFormatter.date(from: self.createdAt)
        
        return Photo(
            id: self.id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: self.description ?? "",
            thumbImageURL: self.urls["thumb"],
            largeImageURL: self.urls["regular"],
            isLiked: self.isLiked
        )
    }
}
