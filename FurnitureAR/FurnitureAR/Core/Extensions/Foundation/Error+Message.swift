//
//  Error+Message.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 07.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension Error {
    var message: String {
        let errorWithInfo = self as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        return errorMessage
    }
}
