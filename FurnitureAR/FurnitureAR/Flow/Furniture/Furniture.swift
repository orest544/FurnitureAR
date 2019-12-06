//
//  Furniture.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

struct Furniture {
    let id: Int
    let name: String
    let description: String
    let imageUrl: URL
}

extension Furniture {
    init?(firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? Int,
            let name = firestoreData["name"] as? String,
            let description = firestoreData["description"] as? String,
            let imageUrlString = firestoreData["image_url"] as? String else {
                return nil
        }
        guard let imageUrl = URL(string: imageUrlString) else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
    }
}
