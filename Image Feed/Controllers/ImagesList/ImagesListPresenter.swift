//
//  ImageListPresenter.swift
//  Image Feed
//
//  Created by Павел Врухин on 12.08.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get }
    var photos: [Photo] { get set }
    var imagesListServiceObserver: NSObjectProtocol? { get }
    
    func fetchPhotosNextPage()
    func changeLike(cell: ImagesListCell, indexPath: IndexPath)
    func updateTableView()
    func createImagesListServiceObserver()
    func getPhotoData(for cell: IndexPath) -> CellData
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var imagesListServiceObserver: NSObjectProtocol?
    
    var photos: [Photo] = []
    
    private let imagesListService = ImagesListService.shared
    private let dateFormatter = DateFormatterService.shared.outputImageDateFormatter
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func createImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.didReceiveImagesListServiceNotification()
            }
    }
    
    func getPhotoData(for cell: IndexPath) -> CellData {
        var imageUrl: URL?
        var createdAt = ""
        var isLiked = false
        
        if let url = photos[cell.row].thumbImageURL {
            imageUrl = URL(string: url)
        }
        
        if let date = photos[cell.row].createdAt {
            createdAt = dateFormatter.string(from: date)
        }
        
        isLiked = photos[cell.row].isLiked
        
        return CellData(thumbImageURL: imageUrl, createdAt: createdAt, isLiked: isLiked)
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                return
            case .failure(let error):
                view?.showImageDownloadErrorAlert(error)
            }
        }
    }
    
    func changeLike(cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            self.view?.lockUI()
            switch result {
            case .success():
                self.photos = self.imagesListService.photos
                self.view?.changeLike(for: cell, isLiked: photos[indexPath.row].isLiked)
                self.view?.unlockUI()
            case .failure(let error):
                self.view?.unlockUI()
                view?.showImageLikeError(error)
            }
        }
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableView(indexPaths: indexPaths)
        }
    }
}
