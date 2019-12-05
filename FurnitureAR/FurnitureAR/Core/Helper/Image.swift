//
//  Image.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 04.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

enum ImageProvider: String, CaseIterable {
    
    case selectedArea
    
    var image: UIImage? {
        return UIImage(named: name)
    }
    
    static func validateImages() {
        allCases.forEach { image in
            let imageName = image.name
            assert(UIImage(named: image.name) != nil,
                   "Image with name: \(imageName), doesn't exist.")
        }
    }
    
    private var name: String {
        return self.rawValue
    }
}
