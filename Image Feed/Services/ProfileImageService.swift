//
//  ProfileImageService.swift
//  Image Feed
//
//  Created by Павел Врухин on 10.07.2023.
//

import Foundation

final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    
    private let tokenStorage = OAuthTokenStorage()
    private let path = "/users"
    private let urlSession = URLSession.shared
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<User, Error>) -> Void) {
        var request = profileImageURLRequest(path: "\(self.path)/\(username)")
        let token = self.tokenStorage.token ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let user = response.convert()
                self.avatarURL = user.avatarURL
                completion(.success(user))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL":self.avatarURL ?? ""]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension ProfileImageService {
    
    func profileImageURLRequest(path: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: path, httpMethod: "GET", baseURL: Credentials.DefaultApiUrl)
    }
}
