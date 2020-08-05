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
    var filteredItemsViewModel = [ItemViewModel]()
    var itemsViewModel = [ItemViewModel]()
    var galleryView = GalleryView()
    weak var galleryCollectionView: UICollectionView!
    weak var errorMessageLabel: UILabel!
    
    lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilter))
        return button
    }()
    
    lazy var tagSearchBarContoller: UISearchController = {
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Search tag"
        searchBar.searchBar.sizeToFit()
        searchBar.searchBar.searchBarStyle = .prominent
        searchBar.searchBar.searchTextField.backgroundColor = .white
        searchBar.searchBar.delegate = self
        searchBar.obscuresBackgroundDuringPresentation = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        fetchData()
        setNavigationBar()
    }
    
    fileprivate func fetchData() {
        Service.shared.fetchCourses { [weak self] (gallery, error) in
            if let error = error {
                self?.errorMessageLabel.text = error.localizedDescription
                self?.errorMessageLabel.isHidden = false
                return
            }
            self?.itemsViewModel = gallery?.items.map({return ItemViewModel(item: $0)}) ?? []
            self?.filteredItemsViewModel = self?.itemsViewModel ?? []
            self?.galleryCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        self.galleryCollectionView = galleryView.galleryCollectionView
        self.errorMessageLabel = galleryView.errorMessageLabel
        view = galleryView
    }
    
    func setNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.searchController = tagSearchBarContoller
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc func showFilter() {
        FilterView.setFilterView(self)
    }
}

extension GalleryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItemsViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GalleryCell
        cell.item = filteredItemsViewModel[indexPath.row]
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
        openImageController.item = filteredItemsViewModel[indexPath.row]
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
            filteredItemsViewModel = itemsViewModel
            galleryCollectionView.reloadData()
            return
        }
        filteredItemsViewModel = itemsViewModel.filter({ (item) -> Bool in
            guard let text = searchBar.text else { return false }
            return item.tags.lowercased().contains(text.lowercased())
        })
        galleryCollectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredItemsViewModel = itemsViewModel
        galleryCollectionView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if filteredItemsViewModel.count == 0 {
            filteredItemsViewModel = itemsViewModel
            galleryCollectionView.reloadData()
            searchBar.text = ""
        }
    }
}
