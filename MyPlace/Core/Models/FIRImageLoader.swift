//
//  FIRImageLoader.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-31.
//

import SwiftUI

class FIRImageLoader: ObservableObject {
    
    @Published var image: Image = Image(systemName: "person.circle.fill")
    
    init(id: String, cache: LRUCache<String, Image>) {
        
        if let imageFromCache = cache.retrieveObject(at: id) {
            print("Loading image from cache")
            self.image = imageFromCache
        } else {
            FirebaseRepository.getFromStorage(path: FIRKeys.StoragePath.profileImages+"/\(id)") { (result) in
                switch result {
                case .failure(let error):
                    print("failed getting image: \(error)")
                case .success(let image):
                    self.image = image
                    cache.setObject(for: id, value: image)
                }
            }
        }
    }
}
