//
//  ProfileResult.swift
//  Image Feed
//
//  Created by Павел Врухин on 08.07.2023.
//

import Foundation

struct ProfileResponse: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    func convert() -> Profile {
        Profile(
            username: self.username,
            name: (self.firstName ?? "") + " " + (self.lastName ?? ""),
            login: "@" + self.username,
            bio: self.bio ?? "")
    }
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
