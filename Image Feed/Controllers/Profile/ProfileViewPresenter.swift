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
    
    func cleanAuthData()
    func getAvatarUrl() -> URL?
    func getProfileDetails() -> Profile?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    var authService = OAuth2Service.shared
    var profileService = ProfileService.shared
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
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
