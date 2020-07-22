//
//  LoadCacheImage.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit
private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadCacheImage(url: String) {
        self.image = nil
        if let cahedImage = imageCache.object(forKey: url as NSString) {
            self.image = cahedImage
            return
        }
        if let imageUrl = URL(string: url) {
            URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: url as NSString)
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
