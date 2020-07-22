//
//  ViewController.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class GalleryController: UIViewController {
    var gallery: Gallery?
    let cellId = "GalleryCell"
    
    let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollectionView()
        fetchData()
        setNavigationBar()
    }
    
    fileprivate func fetchData() {
        Service.shared.fetchCourses { [weak self] (gallery, error) in
            if let error = error {
                print(error)
                return
            }
            self?.gallery = gallery
            self?.galleryCollectionView.reloadData()
        }
    }
    
    func setLayout() {
        view.backgroundColor = .white
        view.addSubview(galleryCollectionView)
        NSLayoutConstraint.activate([galleryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), galleryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), galleryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), galleryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    func setNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
           navigationController?.navigationBar.prefersLargeTitles = true
       }
}

extension GalleryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GalleryCell
        cell.item = gallery?.items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 20) / 3, height: (collectionView.bounds.width - 20) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let openImageController = OpenImageController()
        openImageController.itemsViewModel = gallery?.items.map({return ItemViewModel(item: $0)}) ?? []
        openImageController.index = indexPath
        navigationController?.pushViewController(openImageController, animated: true)
    }
    
    func setCollectionView() {
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.register(GalleryCell.self, forCellWithReuseIdentifier: cellId)
        galleryCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
