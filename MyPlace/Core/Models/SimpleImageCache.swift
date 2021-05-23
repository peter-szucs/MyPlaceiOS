//
//  ImageCache.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import Foundation
import SwiftUI

class SimpleImageCache {
    
    var cache: NSCache<NSString, UIImage> = {
        let returncache = NSCache<NSString, UIImage>()
        returncache.countLimit = 50
        return returncache
    }()
    
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 50, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(forKey key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension SimpleImageCache {
    private static var imageCache = SimpleImageCache()
    static func getImageCache() -> SimpleImageCache {
        return imageCache
    }
}
