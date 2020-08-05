//
//  GalleryView.swift
//  Gallery
//
//  Created by Camilo Cabana on 5/08/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class GalleryView: UIView {
    let galleryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        backgroundColor = .white
        addSubview(galleryCollectionView)
        addSubview(errorMessageLabel)
        galleryCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        galleryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        galleryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        galleryCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
