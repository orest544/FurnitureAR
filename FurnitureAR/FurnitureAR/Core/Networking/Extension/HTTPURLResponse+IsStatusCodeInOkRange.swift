//
//  HTTPURLResponse+IsStatusCodeInOkRange.swift
//
//  Created by Orest Patlyka on 9/5/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isStatusCodeInOkRange: Bool {
        return 200...299 ~= statusCode
    }
}
