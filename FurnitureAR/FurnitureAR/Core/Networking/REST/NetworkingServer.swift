//
//  NetworkingServer.swift
//  CurrencyConvertor
//
//  Created by Orest Patlyka on 9/5/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

enum URLScheme: String {
    case http
    case https
}

protocol NetworkingServerProtocol {
    var scheme: URLScheme { get }
    var host: String { get }
    
    var baseUrl: URL { get }
}

extension NetworkingServerProtocol {
    var baseUrl: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        
        return urlComponents.url!
    }
}

enum NetworkingServer: NetworkingServerProtocol {
    
    case EatStreet
    
    var scheme: URLScheme {
        return .https
    }
    
    var host: String {
        return "reqres.in"
    }
}
