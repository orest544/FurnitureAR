//
//  FurnitureService.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FurnitureService {
    func retrieveAll(completion: @escaping (Result<[Furniture], Error>) -> Void) {
        Firestore.firestore().collection("furniture").getDocuments { (querySnapshot, error) in
            if let error = error {
                return completion(.failure(error))
            }
            guard let snapshot = querySnapshot else {
                return completion(.failure(NetworkingError.badData))
            }
            
            let furnitures = snapshot.documents.compactMap {
                Furniture(firestoreData: $0.data())
            }
            return completion(.success(furnitures))
        }
    }
}
