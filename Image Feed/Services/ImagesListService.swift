//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Павел Врухин on 21.07.2023.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let tokenStorage = OAuthTokenStorage.shared
    private let urlSession = URLSession.shared
    private let path = "/photos"
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        var request = photosRequest(page: nextPage)
        let token = tokenStorage.token ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResponse], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let photosData = response
                for photo in photosData {
                    photos.append(photo.convert())
                }
                completion(.success(photos))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos":self.photos]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private init() {}
}

extension ImagesListService {
    func photosRequest(page: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: self.path
            + "?page=\(page)",
            httpMethod: "GET",
            baseURL: Credentials.DefaultApiUrl
        )
    }
}
