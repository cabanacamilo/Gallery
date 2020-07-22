//
//  OpenImageController.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class OpenImageController: UIViewController {
    var itemsViewModel = [ItemViewModel]()
    let cellId = "OpenImageCell"
    var index = IndexPath()
    
    let openImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout() {
        view.backgroundColor = .white
        view.addSubview(openImageCollectionView)
        NSLayoutConstraint.activate([openImageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), openImageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), openImageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), openImageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCollectionView()
        openImageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in openImageCollectionView.visibleCells {
            guard let newIndex = openImageCollectionView.indexPath(for: cell) else { return }
            index = newIndex
            navigationItem.title = itemsViewModel[index.row].title
        }
    }
}

extension OpenImageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OpenImageCell
        cell.item = itemsViewModel[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func setCollectionView() {
        openImageCollectionView.delegate = self
        openImageCollectionView.dataSource = self
        openImageCollectionView.register(OpenImageCell.self, forCellWithReuseIdentifier: cellId)
    }
}
