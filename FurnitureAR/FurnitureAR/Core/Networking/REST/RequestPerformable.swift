//
//  RequestPerformable.swift
//
//  Created by Orest Patlyka on 9/5/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

protocol RequestPerformable {
    var urlSession: URLSession { get }
    var dataDecoder: JSONDecoder { get }
    
    func performDataTask<T: Decodable>(with endpoint: URLConstructable,
                                       completion: @escaping RequestedDataCompletion<T>)
}

extension RequestPerformable {
    typealias RequestedDataResult<T: Decodable> = Result<T, NetworkingError>
    typealias RequestedDataCompletion<T: Decodable> = (RequestedDataResult<T>) -> Void
    
    var urlSession: URLSession {
        let configurations = URLSessionConfiguration.default
        configurations.waitsForConnectivity = NetworkingConfigurations.waitsForConnectivity
        configurations.timeoutIntervalForResource = NetworkingConfigurations.timeoutIntervalForResource
        
        return URLSession(configuration: configurations)
    }
    
    var dataDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
    
    func performDataTask<T: Decodable>(with endpoint: URLConstructable,
                                       completion: @escaping RequestedDataCompletion<T>) {
        typealias ParsedDataType = T
        
        let url = endpoint.asUrl
        let request = URLRequest(url: url)
        
        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(.commonError(error)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.badResponse))
            }
            
            guard response.isStatusCodeInOkRange else {
                return completion(.failure(.badStatusCode(response.statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let parsedModel = try self.dataDecoder.decode(ParsedDataType.self, from: data)
                return completion(.success(parsedModel))
            } catch let catchError {
                return completion(.failure(.commonError(catchError)))
            }
        }.resume()
    }
}


