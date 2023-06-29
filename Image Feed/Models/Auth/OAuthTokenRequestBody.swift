//
//  OAuthTokenRequestBody.swift
//  Image Feed
//
//  Created by Павел Врухин on 27.06.2023.
//

import Foundation

struct OAuthTokenRequestBody: Encodable {
    
    let clientID: String
    let clientSecret: String
    let redirectURI: String
    let code: String
    let grantType: String
    
    private enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case code
        case grantType = "grant_type"
    }
}
