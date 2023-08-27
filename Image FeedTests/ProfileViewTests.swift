//
//  ProfileViewTests.swift
//  Image FeedTests
//
//  Created by Павел Врухин on 24.08.2023.
//

@testable import Image_Feed
import XCTest

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var updateProfileDetailsCalled = false
    
    var view: ProfileViewControllerProtocol?
    
    var authService: OAuth2Service = OAuth2Service.shared
    var profileService: ProfileService = ProfileService.shared
    var profileImageServiceObserver: NSObjectProtocol?
    
    func cleanAuthData() {}
    
    func getAvatarUrl() -> URL? { nil }
    
    func getProfileDetails() -> Profile? {
        updateProfileDetailsCalled = true
        return nil
    }
    
    func createProfileImageServiceObserver() {}
}

final class ProfileViewTests: XCTestCase {
    func testUpdateProfileDetailsCalled() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.updateProfileDetailsCalled)
    }
}
