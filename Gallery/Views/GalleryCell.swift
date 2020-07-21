//
//  GalleryCell.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    var item: Item! {
        didSet {
            galleryImage.loadCacheImage(url: item.media.m)
        }
    }
    
    let galleryImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    func setLayout() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        addSubview(galleryImage)
        NSLayoutConstraint.activate([galleryImage.leadingAnchor.constraint(equalTo: leadingAnchor), galleryImage.topAnchor.constraint(equalTo: topAnchor), galleryImage.bottomAnchor.constraint(equalTo: bottomAnchor), galleryImage.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
