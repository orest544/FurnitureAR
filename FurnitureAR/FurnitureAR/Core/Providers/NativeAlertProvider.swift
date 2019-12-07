//
//  NativeAlertProvider.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 07.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

class NativeAlertProvider {
    static func networkingProblems(_ reasonMessage: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Internet connection issues",
                                                message: reasonMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        return alertController
    }
}
