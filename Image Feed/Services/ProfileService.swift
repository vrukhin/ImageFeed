//
//  ProfileService.swift
//  Image Feed
//
//  Created by Павел Врухин on 08.07.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    private let path = "/me"
    private let urlSession = URLSession.shared
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        var request = profileRequest(token: token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let profileData = response.convert()
                profile = profileData
                completion(.success(profileData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private init() {}
}

extension ProfileService {
    
    private func profileRequest(token: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: self.path, httpMethod: "GET")
    }
}
