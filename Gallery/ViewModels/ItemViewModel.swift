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
    let description: String
    let tags: String
    let dateTaken: Date
    let datePublished: Date
    
    init(item: Item) {
        self.title = item.title
        self.author = item.author
        self.image = item.media.m
        self.dateTaken = item.date_taken.stringToDate()
        self.datePublished = item.published.stringToDate()
        self.description = item.description
        self.tags = item.tags
    }
}
