//
//  FilterView.swift
//  Gallery
//
//  Created by Camilo Cabana on 31/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class FilterView {
    static let filterView = FilterView()
    
    func setLayout(_ vc: GalleryController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionSortedByPublished = UIAlertAction(title: "By Published", style: .default) { [weak vc] (_) in
            vc?.filteredItemsViewModel.sort { $0.datePublished < $1.datePublished }
            vc?.galleryCollectionView.reloadData()
        }
        let actionSortedByDateTaken = UIAlertAction(title: "By Date Taken", style: .default) { [weak vc] (_) in
            vc?.filteredItemsViewModel.sort { $0.dateTaken < $1.dateTaken }
            vc?.galleryCollectionView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionSortedByPublished)
        alert.addAction(actionSortedByDateTaken)
        alert.addAction(actionCancel)
        vc.present(alert, animated: true)
    }
}
