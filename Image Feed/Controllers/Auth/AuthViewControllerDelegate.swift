//
//  AuthViewControllerDelegate.swift
//  Image Feed
//
//  Created by Павел Врухин on 01.07.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticate code: String)
}
