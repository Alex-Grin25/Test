//
//  CacheManager.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 16.03.2021.
//

import Foundation
import UIKit

class CacheManager {

    private static let instance = CacheManager()
    
    private init() {}
    
    private func loadImage(_ url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
    
    private let cacheLifeTime: TimeInterval = 7 * 24 * 60 * 60
    private var images = [String: UIImage]()
    
    private func getCacheURL() -> URL? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let url = cachesDirectory.appendingPathComponent("images", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    private func loadPhoto(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString), let data = loadImage(url) else { return nil }
        if let fileName = getCacheURL()?.appendingPathComponent("\(urlString.hash)").path {
            FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
        }
        images[urlString] = UIImage(data: data)
        return images[urlString]
    }
    
    private func getImageFromCache(_ urlString: String) -> UIImage? {
        return nil //TODO: remove
        guard
            let fileName = getCacheURL()?.appendingPathComponent("\(urlString.hash)").path,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        DispatchQueue.main.async { [weak self] in
            self?.images[urlString] = image
        }
        return image
    }
    
    private func getImage(_ urlString: String) -> UIImage? {
        /*
         do {
             let realm = try Realm()
             let result = Array(realm.objects(PhotoData.self).filter("url == %@", urlString))
             if result.count > 0, let data = result[0].data {
                 cell2.imageView.image = UIImage(data: data)
                 if result.count > 1 {
                     print("More than 1 photo in Realm for url: \(urlString)")
                 }
             }
             else if let url = URL(string:urlString),
                     let data = try? Data(contentsOf: url) {
                 sleep(1)
                 let photoData = PhotoData()
                 photoData.url = urlString
                 photoData.data = data
                 
                 realm.beginWrite()
                 realm.add(photoData)
                 try realm.commitWrite()
                 
                 cell2.imageView.image = UIImage(data: data)
             }
         } catch {
             print(error)
         }
         */
        
        var image: UIImage?
        if let photo = images[urlString] {
            image = photo
        } else if let photo = getImageFromCache(urlString) {
            image = photo
        } else {
            image = loadPhoto(urlString)
        }
        return image
    }
    
    func getImageAsync(_ urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        var image: UIImage?
        if let photo = images[urlString] {
            image = photo
        } else if let photo = getImageFromCache(urlString) {
            image = photo
        } else {
            NetworkService.instance.loadPhotoAsync(urlString: urlString) { (image) in
                if image != nil {
                    self.images[urlString] = image
                    completionHandler(image)
                }
            }
        }
        
        if image != nil {
            completionHandler(image)
        }
    }
    
    static func getImage(_ urlString: String) -> UIImage? {
        return self.instance.getImage(urlString)
    }
    
    static func getImageAsync(_ urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        return self.instance.getImageAsync(urlString, completionHandler: completionHandler)
    }
}
