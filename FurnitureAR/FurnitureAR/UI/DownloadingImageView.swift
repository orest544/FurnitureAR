//
//  DownloadingImageView.swift
//
//  Created by Orest Patlyka on 8/3/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

class DownloadingImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImage(from imageUrlString: String,
                   placeholderImage: UIImage? = nil) {
        guard let imageUrl = URL(string: imageUrlString) else { return }
        self.imageUrlString = imageUrlString
        
        image = placeholderImage
        
        ImageDownloader.downloadImageData(from: imageUrl) { [weak self] (imageData) in
            guard let self = self else { return }
            
            guard let data = imageData,
                let downloadedImage = UIImage(data: data) else {
                    return
            }
            
            DispatchQueue.main.async(group: nil, qos: .userInteractive, flags: .barrier) {
                if self.imageUrlString == imageUrlString {
                    self.image = downloadedImage
                }
            }
        }
    }
}

enum ImageDownloader {
    static func downloadImageData(from imageUrl: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
            completion(data)
        }.resume()
    }
}
