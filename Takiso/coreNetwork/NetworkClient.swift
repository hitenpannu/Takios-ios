//
//  NetworkClient.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

typealias OnCompletion<T: Decodable> = (T?, Error?) -> Void

protocol NetworkClientDelegate {
    func didSuccess<T: Decodable>(data: T)
    func didFailWith(errorMessage: String)
}

typealias NetworkRequestCompletionHandler<T: Decodable> = (T?, Error?) -> Void

protocol NetworkClient {
    func makeRequest<T: Decodable>(networkRequest: URLRequest, completionHandler : @escaping NetworkRequestCompletionHandler<T>)
}

class NetworkRequestBuilder{
    
    var requestUrl : URL
    
    var method: String = "GET"
    
    var body: Data?
    
    var headers: [String :  String] = [:]
    
    init(url: URL) {
        requestUrl = url
    }
    
    func addHeader(key: String, value: String) -> NetworkRequestBuilder{
        headers[key] = value
        return self
    }
    
    func addBody<T: Encodable>(requestBody: T) -> NetworkRequestBuilder {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(requestBody)
            self.body = encoded
        } catch {
            print(error)
        }
        return self
    }
    
    func build() -> URLRequest {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method
        if body != nil {
            request.httpBody = body
        }
        if !headers.isEmpty {
            headers.forEach { (key: String, value: String) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}

class NetworkClientImpl: NetworkClient{
    
    func makeRequest<T: Decodable>(networkRequest: URLRequest, completionHandler : @escaping NetworkRequestCompletionHandler<T>) {
               let task = URLSession.init(configuration: .default)
                   .dataTask(with: networkRequest) { (data, response, error) in
                    
                       if let safeError = error {
                           print(error.debugDescription)
                           completionHandler(nil, safeError)
                           return
                       }
                       
                       if let safeData = data {
                           let decoder = JSONDecoder()
                           do {
                            let networkResponse = try decoder.decode(NetworkResponse<T>.self, from: safeData)
                            if(networkResponse.data != nil) {
                                completionHandler(networkResponse.data, nil)
                            }else if(networkResponse.status.code == NetworkConstants.STATUS_SUCCESS) {
                                completionHandler(nil, nil)
                            }else {
                                completionHandler(nil, error)
                            }
                           } catch {
                            print(error)
                                completionHandler(nil, error)
                           }
                       }
               }
               
               task.resume()
    }
}
