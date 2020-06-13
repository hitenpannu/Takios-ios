//
//  NetworkClient.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

typealias OnCompletion<T: Decodable> = (T?, Error?) -> Void

typealias NetworkRequestCompletionHandler<T: NetworkResponse> = (T?, TakisoException?) -> Void

protocol NetworkClient {
    func makeRequest<T: NetworkResponse>(networkRequest: URLRequest, completionHandler : @escaping NetworkRequestCompletionHandler<T>)
}

class NetworkRequestBuilder{
    
    enum RequestMethod : String {
        case POST = "POST"
        case GET = "GET"
    }
    
    var requestUrl : URL
    
    var method: RequestMethod = RequestMethod.GET
    
    var body: Data?
    
    var headers: [String :  String] = [:]
    
    init(url: URL) {
        requestUrl = url
    }
    
    func useMethod(method: RequestMethod) -> NetworkRequestBuilder {
        self.method = method
        return self
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
        request.httpMethod = method.rawValue
        if body != nil {
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
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
    
    func makeRequest<T: NetworkResponse>(networkRequest: URLRequest, completionHandler : @escaping NetworkRequestCompletionHandler<T>) {
        let task = URLSession.init(configuration: .default)
            .dataTask(with: networkRequest) { (data, response, error) in
                
                if let safeError = error {
                    completionHandler(nil, ServerError(message: safeError.localizedDescription))
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let networkResponse = try decoder.decode(T.self, from: safeData)
                        if(networkResponse.data != nil) {
                            completionHandler(networkResponse, nil)
                        }else if(networkResponse.status.code == NetworkConstants.STATUS_SUCCESS) {
                            completionHandler(nil, nil)
                        }else {
                            completionHandler(nil, ServerError(message:networkResponse.status.message))
                        }
                    } catch {
                        print(error)
                        completionHandler(nil, ServerError(message: error.localizedDescription))
                    }
                }
        }
        
        task.resume()
    }
}
