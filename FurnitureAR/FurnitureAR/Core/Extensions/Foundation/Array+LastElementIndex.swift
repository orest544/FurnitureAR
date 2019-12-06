//
//  Array+LastElementIndex.swift
//  NERVY
//
//  Created by Orest Patlyka on 7/25/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension Array {
    var lastElementIndex: Int? {
        guard hasElements else { return nil }
        return count - 1
    }
}
