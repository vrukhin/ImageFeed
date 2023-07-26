//
//  SplashViewController.swift
//  Image Feed
//
//  Created by Павел Врухин on 30.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private var logoImageView: UIImageView!
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegue"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuthTokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createSplashView()
        
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    private func createSplashView() {
        view.backgroundColor = .ypBlack
        
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "splash_screen_logo")
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticate code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
    
    private func fetchAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                
                let alert = UIAlertController(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileData):
                profileImageService.fetchProfileImageURL(username: profileData.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                
                let alert = UIAlertController(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
