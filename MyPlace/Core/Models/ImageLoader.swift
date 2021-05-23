//
//  ImageLoader.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-04-01.
//

import SwiftUI
import Combine
import FirebaseStorage

final class ImageLoader: ObservableObject {
    let objectWillChange = PassthroughSubject<UIImage, Never>()
//    let objectWillChange = PassthroughSubject<Data?, Never>()
//    let cache = Cache<String, UIImage?>()
    var imageCache = SimpleImageCache.getImageCache()
    
//    private let cache: ImageCacheType = ImageCache()
    
    
    var data: UIImage? = nil {
        didSet { objectWillChange.send(data!) }
    }
//    var data: Data? = nil {
//        didSet { objectWillChange.send(data) }
//    }
    
    init(_ id: String) {
        let url = "profileImages/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
//        print("!!ImageLoader: cacheID: \(String(describing: cache[id]))")
        print("!!ImageLoader: cacheID: \(String(describing: imageCache.get(forKey: id)))")
//        if let cached = cache[id] {
        if let cached = imageCache.get(forKey: id){
            print("!!! ImageLoader: Image loaded from Cache.")
            DispatchQueue.main.async {
                self.data = cached
            }
        } else {
            ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("\(error)")
                }
                guard let data = data else { return }
//                var image: UIImage { data.flatMap(UIImage.init)! }
                guard let image: UIImage = UIImage(data: data) else { return }
                let decodedImage = image.decodedImage()
//                self.cache[id] = decodedImage
                
                self.imageCache.set(forKey: id, image: decodedImage)
                DispatchQueue.main.async {
//                    self.data = data
                    self.data = image
                }
            }
        }
        
    }
}
