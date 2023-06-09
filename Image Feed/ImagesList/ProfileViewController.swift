//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Павел Врухин on 09.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
