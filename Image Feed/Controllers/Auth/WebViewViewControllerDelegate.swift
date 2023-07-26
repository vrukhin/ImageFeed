//
//  WebViewViewControllerDelegate.swift
//  Image Feed
//
//  Created by Павел Врухин on 25.06.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
