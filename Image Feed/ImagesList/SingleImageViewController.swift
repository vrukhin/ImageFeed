//
//  SingleImageViewController.swift
//  Image Feed
//
//  Created by Павел Врухин on 10.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
