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
        let task = object(for: request) { [weak self] result in
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
}

extension ProfileService {
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResponse, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResponse, Error> in
                Result {
                    try decoder.decode(ProfileResponse.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    private func profileRequest(token: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: self.path, httpMethod: "GET", baseURL: Credentials.DefaultApiUrl)
    }
}
