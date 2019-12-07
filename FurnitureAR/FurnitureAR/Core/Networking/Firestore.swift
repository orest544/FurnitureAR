//
//  Firestore.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FirestoreEndpoint {
    var collection: String { get }
    var document: String? { get }
}

protocol FirestoreRequestPerformable: RequestPerformable {
    func performFirestore<T: Decodable>(with endpoint: FirestoreEndpoint,
                                        completion: FirestoreRequestCompletion<T>)
}

extension FirestoreRequestPerformable {
    typealias FirestoreRequestCompletion<T: Decodable> = (FirestoreRequestResult<T>) -> Void
    typealias FirestoreRequestResult<T: Decodable> = Result<T, Error>
    
    
    func performFirestore<T: Decodable>(with endpoint: FirestoreEndpoint,
                                        completion: @escaping FirestoreRequestCompletion<T>) {
//        if let document = endpoint.document {
//            return
//        }
//        
//        Firestore.firestore().collection(endpoint.collection).getDocuments { (snapshot, error) in
// 
//        }
    }
}
