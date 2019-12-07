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
        let alertController = UIAlertController(title: "Немає з'єднання з Інтернет",
                                                message: reasonMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Продовжити", style: .default)
        alertController.addAction(okAction)
        
        return alertController
    }
}
