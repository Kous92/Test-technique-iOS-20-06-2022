//
//  ImageResultCollectionViewCell.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import UIKit
import Kingfisher

class ImageResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionView: UIView!
    
    func configure(with image: Hit) {
        setSelected()
        guard let url = image.previewURL, let imageURL = URL(string: url) else {
            return
        }
        
        imageView.kf.indicatorType = .activity
        let options: KingfisherOptionsInfo = [.transition(.fade(0.5))]
        imageView.kf.setImage(with: imageURL, options: options)
    }
    
    func setSelected() {
        selectionView.backgroundColor = self.isSelected ? .systemBlue : .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
