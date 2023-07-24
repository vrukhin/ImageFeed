//
//  OAuthTokenStorage.swift
//  Image Feed
//
//  Created by Павел Врухин on 29.06.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    
    static let shared = OAuthTokenStorage()
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        }
        
        set {
            guard let token = newValue else {
                KeychainWrapper.standard.removeObject(forKey: "Auth token")
                return
            }
            KeychainWrapper.standard.set(token, forKey: "Auth token")
        }
    }
    
    private init() {}
}
