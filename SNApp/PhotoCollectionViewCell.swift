//
//  PhotoCollectionViewCell.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 02.03.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure() {
        if self.imageView == nil {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.contentView.frame.size))
            imageView.translatesAutoresizingMaskIntoConstraints = true
            self.imageView = imageView
            self.contentView.addSubview(self.imageView)
        }
    }
}
