//
//  ImageListPresenter.swift
//  Image Feed
//
//  Created by Павел Врухин on 12.08.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get }
    var imagesListService: ImagesListService { get }
    var photos: [Photo] { get set }
    
    func fetchPhotosNextPage()
    func changeLike(cell: ImagesListCell, indexPath: IndexPath)
    func updateTableView()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    let imagesListService = ImagesListService.shared
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
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
