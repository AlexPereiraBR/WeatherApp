//
//  ImageCacheManager.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 07/05/25.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    //MARK: - Singleton
    
    static let shared = ImageCacheManager()
    private init() {
        cache.countLimit = 50

    }
    
    //MARK: - Properties
    
    private let cache = NSCache<NSString, UIImage>()
    
    //MARK: - Public Methods
    
        func image(forKey key: String) -> UIImage? {
            
        return cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)

        var keys = UserDefaults.standard.stringArray(forKey: "CachedKeys") ?? []
        if !keys.contains(key) {
            keys.append(key)
            UserDefaults.standard.set(keys, forKey: "CachedKeys")
        }
    }
}
