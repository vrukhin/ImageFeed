//
//  ProfileViewPresenter.swift
//  Image Feed
//
//  Created by Павел Врухин on 09.08.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get }
    var authService: OAuth2Service { get }
    var profileService: ProfileService { get }
    var profileImageServiceObserver: NSObjectProtocol? { get }
    
    func cleanAuthData()
    func getAvatarUrl() -> URL?
    func getProfileDetails() -> Profile?
    func createProfileImageServiceObserver()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    
    var authService = OAuth2Service.shared
    var profileService = ProfileService.shared
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func createProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
    }
    
    func cleanAuthData() {
        authService.clean()
    }
    
    func getAvatarUrl() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func getProfileDetails() -> Profile? {
        return profileService.profile
    }
}
