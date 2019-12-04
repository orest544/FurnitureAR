//
//  NetworkingError.swift
//  CurrencyConvertor
//
//  Created by Orest Patlyka on 9/5/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case commonError(Error)
    case badData
    case badResponse
    case badStatusCode(Int)
}
