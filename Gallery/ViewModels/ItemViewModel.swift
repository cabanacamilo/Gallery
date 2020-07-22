//
//  OpenImageViewModel.swift
//  Gallery
//
//  Created by Camilo Cabana on 22/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

struct ItemViewModel {
    let title: String
    let author: String
    let image: String
    let dateTaken: String
    let datePublished: String
    let description: String
    init(item: Item) {
        self.title = item.title
        self.author = item.author
        self.image = item.media.m
        let dateTaken = item.date_taken.stringToDate()
        let date = DateFormatter()
        date.dateFormat = "MMM d, yyyy"
        self.dateTaken = date.string(from: dateTaken)
        let datePublished = item.published.stringToDate()
        self.datePublished = date.string(from: datePublished)
        self.description = item.description
    }
}
