//
//  UserResponse.swift
//  Image Feed
//
//  Created by Павел Врухин on 10.07.2023.
//

import Foundation

struct UserResponse: Codable {
    let profileImage: Dictionary<String, String>
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    func convert() -> User {
        User(avatarURL: profileImage["small"])
    }
}
