//
//  ViewController.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class GalleryController: UIViewController {
    let cellId = "GalleryCell"
    var filteredItems = [ItemViewModel]()
    var items = [ItemViewModel]()
    
    let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var tagSearchBarContoller: UISearchController = {
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Search country"
        searchBar.searchBar.sizeToFit()
        searchBar.searchBar.searchBarStyle = .prominent
        searchBar.searchBar.searchTextField.backgroundColor = .white
        searchBar.searchBar.delegate = self
        searchBar.obscuresBackgroundDuringPresentation = false
        return searchBar
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
            self?.items = gallery?.items.map({return ItemViewModel(item: $0)}) ?? []
            self?.filteredItems = self?.items ?? []
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
        navigationItem.searchController = tagSearchBarContoller
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension GalleryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GalleryCell
        cell.item = filteredItems[indexPath.row]
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
        openImageController.item = filteredItems[indexPath.row]
        navigationController?.pushViewController(openImageController, animated: true)
    }
    
    func setCollectionView() {
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.register(GalleryCell.self, forCellWithReuseIdentifier: cellId)
        galleryCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension GalleryController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredItems = items
            galleryCollectionView.reloadData()
            return
        }
        filteredItems = items.filter({ (item) -> Bool in
            guard let text = searchBar.text else { return false }
            return item.tags.lowercased().contains(text.lowercased())
        })
        galleryCollectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredItems = items
        galleryCollectionView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if filteredItems.count == 0 {
            filteredItems = items
            galleryCollectionView.reloadData()
            searchBar.text = ""
        }
    }
}
