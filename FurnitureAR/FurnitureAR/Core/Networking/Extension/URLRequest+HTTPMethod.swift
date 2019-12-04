//
//  URLRequest.swift
//  CurrencyConvertor
//
//  Created by Orest Patlyka on 9/5/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func setHTTPMethod(_ method: HTTPMethod) {
        httpMethod = method.rawValue
    }
}
