//
//  FurnitureListViewController.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

class FurnitureListViewController: UIViewController {
    
    private let furnitureService = FurnitureService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        furnitureService.retrieveAll { result in
            switch result {
            case .success(let furnitures):
                print("Success!\n", furnitures)
            
            case .failure(let error):
                let errorWithInfo = error as NSError
                let messages = [
                    errorWithInfo.localizedDescription,
                    errorWithInfo.localizedFailureReason,
                    errorWithInfo.localizedRecoverySuggestion
                ]
                
                let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
                print(errorMessage)
            }
        }
    }
}
