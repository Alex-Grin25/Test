//
//  PhotoCollectionViewCell.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 02.03.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func configure() {
        if self.imageView == nil {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.contentView.frame.size))
            let x = (self.frame.size.width - imageView.frame.size.width) / 2
            imageView.translatesAutoresizingMaskIntoConstraints = true
            self.imageView = imageView
            self.contentView.addSubview(self.imageView)
        }
        self.imageView.image = nil
    }
    
    func loadImage(urlString: String) {
        self.activityIndicatorView.startAnimating()
        CacheManager.getImageAsync(urlString) { [weak self] (image) in
            guard let self = self else { return }
            self.imageView.image = image
            self.activityIndicatorView.stopAnimating()
        }
    }
}
