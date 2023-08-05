//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Павел Врухин on 21.07.2023.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private var task: URLSessionTask?
    private let tokenStorage = OAuthTokenStorage.shared
    private let urlSession = URLSession.shared
    private let path = "/photos"
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
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
                lastLoadedPage = nextPage
                let photosData = response
                for photo in photosData {
                    photos.append(photo.convert())
                }
                self.task = nil
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos":self.photos]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        var request = changeLikeRequest(photoId: photoId, isLike: isLike)
        let token = tokenStorage.token ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success:
                if let index = photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
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
            httpMethod: "GET"
        )
    }
    
    func changeLikeRequest(photoId: String, isLike: Bool) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: self.path
            + "/\(photoId)/like",
            httpMethod: isLike ? "POST" : "DELETE"
        )
    }
}
