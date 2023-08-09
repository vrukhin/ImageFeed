//
//  ImagesListCellDelegate.swift
//  Image Feed
//
//  Created by Павел Врухин on 24.07.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
