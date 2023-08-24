//
//  ImagesListViewTests.swift
//  Image FeedTests
//
//  Created by Павел Врухин on 24.08.2023.
//

@testable import Image_Feed
import XCTest

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListServiceObserver: NSObjectProtocol?
    
    var createImagesListServiceObserverCalled = false
    var fetchPhotosNextPageCalled = false
    var updateTableViewCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(cell: ImagesListCell, indexPath: IndexPath) {}
    
    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func createImagesListServiceObserver() {
        createImagesListServiceObserverCalled = true
    }
    
    func getPhotoData(for cell: IndexPath) -> CellData {
        CellData(thumbImageURL: nil, createdAt: "", isLiked: false)
    }
}

final class ImagesListViewTests: XCTestCase {
    func testCreateImagesListServiceObserver() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.createImagesListServiceObserverCalled)
    }
    
    func testFetchPhotosNextPageCalled() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testUpdateTableViewCalled() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.didReceiveImagesListServiceNotification()
        
        //then
        XCTAssertTrue(presenter.updateTableViewCalled)
    }
}
