//
//  URLConstructable.swift
//
//  Created by Orest Patlyka on 9/5/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

protocol URLConstructable {
    var server: NetworkingServerProtocol { get }
    var path: String { get }
    
    var asUrl: URL { get }
}

extension URLConstructable {
    var asUrl: URL {
        return server.baseUrl.appendingPathComponent(path)
    }
}
