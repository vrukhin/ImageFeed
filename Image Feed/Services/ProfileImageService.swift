//
//  ProfileImageService.swift
//  Image Feed
//
//  Created by Павел Врухин on 10.07.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private(set) var avatarURL: User?
    
    private let tokenStorage = OAuthTokenStorage()
    private let path = "/users"
    private let urlSession = URLSession.shared
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<User, Error>) -> Void) {
        var request = profileImageURLRequest(path: "\(self.path)/\(username)")
        let token = self.tokenStorage.token ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let user = response.convert()
                self.avatarURL = user
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension ProfileImageService {
    
    func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResponse, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResponse, Error> in
                Result {
                    try decoder.decode(UserResponse.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    func profileImageURLRequest(path: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: path, httpMethod: "GET", baseURL: Credentials.DefaultApiUrl)
    }
}
