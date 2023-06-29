//
//  OAuthTokenStorage.swift
//  Image Feed
//
//  Created by Павел Врухин on 29.06.2023.
//

import Foundation

final class OAuthTokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get {
            return userDefaults.string(forKey: "token") ?? "Token not found"
        }
        
        set {
            return userDefaults.set(newValue, forKey: "token")
        }
    }
}
