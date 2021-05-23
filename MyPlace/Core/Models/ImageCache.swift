//
//  ImageCache.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import Foundation
import SwiftUI

// Declares in-memory image cache
protocol ImageCacheType: class {
    // Returns the image associated with a given url
    func image(for id: String) -> UIImage?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for id: String)
    // Removes the image of the specified url in the cache
    func removeImage(for id: String)
    // Removes all images from the cache
    func removeAllImages()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ id: String) -> UIImage? { get set }
}


final class ImageCache {
    
    // 1st level cache, that contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    // 2nd level cache, that contains decoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 50, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache: ImageCacheType {
    
    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
    
    func insertImage(_ image: UIImage?, for id: String) {
        guard let image = image else { return removeImage(for: id) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        print("!!! ### insert: \(decodedImage)")
        imageCache.setObject(decodedImage, forKey: id as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: id as AnyObject, cost: decodedImage.diskSize)
    }

    func removeImage(for id: String) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: id as AnyObject)
        decodedImageCache.removeObject(forKey: id as AnyObject)
    }
}

extension ImageCache {
    func image(for id: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: id as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: id as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: id as AnyObject, cost: decodedImage.diskSize)
            return decodedImage
        }
        return nil
    }
}

// define subscript
extension ImageCache {
    subscript(_ key: String) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}

extension UIImage {
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
    
    // Rough estimation of how much memory image uses in bytes
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
