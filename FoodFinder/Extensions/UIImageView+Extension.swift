//
//  UIImageView+Extension.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import UIKit

class ImageCache: NSObject {
    static let shared = ImageCache()
    
    private override init() { }
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    func add(image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url as AnyObject)
    }
    
    func image(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url as AnyObject) as? UIImage
    }
}

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        if let cachedImage = ImageCache.shared.image(for: url) {
            self.image = cachedImage
        } else {
            downloadImage(url: url, placeholder: placeholder)
        }
    }
    
    private func downloadImage(url: URL, placeholder: UIImage?) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCache.shared.add(image: downloadedImage, for: url)
                    self.image = downloadedImage
                }
            } else {
                DispatchQueue.main.async {
                    self.image = placeholder
                }
            }
        }.resume()
    }
}

