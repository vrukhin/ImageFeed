//
//  Photo.swift
//  Image Feed
//
//  Created by Павел Врухин on 21.07.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}
