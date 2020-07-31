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
    
    let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilter))
        return button
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
                self?.errorMessageLabel.text = error.localizedDescription
                self?.errorMessageLabel.isHidden = false
                return
            }
            self?.itemsViewModel = gallery?.items.map({return ItemViewModel(item: $0)}) ?? []
            self?.filteredItemsViewModel = self?.itemsViewModel ?? []
            self?.galleryCollectionView.reloadData()
        }
    }
    
    func setLayout() {
        view.backgroundColor = .white
        view.addSubview(galleryCollectionView)
        view.addSubview(errorMessageLabel)
        NSLayoutConstraint.activate([
            galleryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), galleryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), galleryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), galleryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
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
