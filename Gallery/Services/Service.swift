//
//  Service.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service()
    
    func fetchCourses(completion: @escaping (Gallery?, Error?) -> ()) {
        let urlString = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                print(error)
                return
            }
            guard let data = data else { return }
            do {
                let gallery = try JSONDecoder().decode(Gallery.self, from: data)
                DispatchQueue.main.async {
                    completion(gallery, nil)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
}
