//
//  Gallery.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import Foundation

struct Gallery: Decodable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [Item]
}

struct Item: Decodable {
    let title: String
    let link: String
    let media: Media
    let date_taken: String
    let description: String
    let published: String
    let author: String
    let author_id: String
    let tags: String
}

struct Media: Decodable {
    let m: String
}
