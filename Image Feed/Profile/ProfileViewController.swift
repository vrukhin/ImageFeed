//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Павел Врухин on 09.06.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    private var avatarImage: UIImageView!
    private var exitButton: UIButton!
    private var nameLabel: UILabel!
    private var usernameLabel: UILabel!
    private var textLabel: UILabel!
    
    private let authService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()
            }
        createProfileView()
        createConstraints()
        updateProfileDetails()
    }
    
    @objc private func exitButtonDidTap(_ sender: UIButton!) {
        
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        let confirmExitAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.authService.clean()
            self.window.rootViewController = SplashViewController()
            self.window.makeKeyAndVisible()
        }
        
        let cancelExitAction = UIAlertAction(title: "Нет", style: .default) { _ in }
        
        alert.addAction(confirmExitAction)
        alert.addAction(cancelExitAction)
        
        self.present(alert, animated: true)
    }
    
    private func updateProfileDetails() {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            usernameLabel.text = profile.login
            textLabel.text = profile.bio
        }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.circle.fill")
        )
    }
    
    private func createProfileView() {

        avatarImage = UIImageView()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        view.addSubview(avatarImage)

        let buttonImage = UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage()
        exitButton = UIButton.systemButton(with: buttonImage, target: self, action: nil)
        exitButton.tintColor = .ypRed
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(self.exitButtonDidTap), for: .touchUpInside)
        view.addSubview(exitButton)
        
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        usernameLabel = UILabel()
        usernameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        usernameLabel.textColor = .ypGray
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        
        textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 13, weight: .regular)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .ypWhite
        view.addSubview(textLabel)
    }
    
    private func createConstraints() {
        
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            
            usernameLabel.heightAnchor.constraint(equalToConstant: 18),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            
            textLabel.heightAnchor.constraint(equalToConstant: 18),
            textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
        ])
    }
}
