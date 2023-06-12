//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Павел Врухин on 09.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var avatarImage: UIImageView!
    private var exitButton: UIButton!
    private var nameLabel: UILabel!
    private var usernameLabel: UILabel!
    private var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileView()
        createConstraints()
    }
    
    private func exitButtonDidTap() {
        
    }
    
    private func createProfileView() {

        let image = UIImage(systemName: "person.crop.circle.fill")
        avatarImage = UIImageView(image: image)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImage)

        let buttonImage = UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage()
        exitButton = UIButton.systemButton(with: buttonImage, target: self, action: nil)
        exitButton.tintColor = .ypRed
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        usernameLabel = UILabel()
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        usernameLabel.textColor = .ypGray
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        
        textLabel = UILabel()
        textLabel.text = "Hello World!!!"
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
