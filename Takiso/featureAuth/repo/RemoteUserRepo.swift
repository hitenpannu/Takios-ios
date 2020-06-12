//
//  RemoteUserRepo.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

typealias OnAuthCompletion = (UserEntity?, Error?) -> Void

struct UrlNotInitialized : Error {
    var localizedDescription: String = "Failed to initialize URL"
}

protocol RemoteUserRepo {
    
    func loginUser(email: String, password: String, onCompletion : @escaping OnAuthCompletion)
    
    func signupUser(name: String, email: String, password: String, onCompletion : @escaping OnAuthCompletion)
    
    func logout(userAuthToken: String, onCompletion : @escaping (Error?) -> Void)
}

class RemoteUserRepoImpl: RemoteUserRepo{

    var networkClient : NetworkClient = NetworkClientImpl()
    
    func loginUser(email: String, password: String, onCompletion : @escaping OnAuthCompletion) {
        guard let loginUrl = URL.init(string: NetworkConstants.BASE_URL + NetworkConstants.ENDPOINT_LOGIN) else {
            onCompletion(nil, UrlNotInitialized())
            return
        }
        
        let networkRequest = NetworkRequestBuilder.init(url: loginUrl)
            .addBody(requestBody: LoginRequest.init(email: email, password: password))
            .build()
        
        networkClient.makeRequest(networkRequest: networkRequest) { (data: NetworkAuthSuccessResponse?, error: Error?) in
            if let safeError = error {
                onCompletion(nil, safeError)
                return
            }
            if let networkUserResponse = data {
                let userEntity = UserEntity.init(
                    name: networkUserResponse.user.name,
                    email: networkUserResponse.user.email,
                    id: networkUserResponse.user._id,
                    usertoken: networkUserResponse.token)
                onCompletion(userEntity, nil)
            }
        }
    }
    
    func signupUser(name: String, email: String, password: String, onCompletion: @escaping OnAuthCompletion) {
       guard let signupUrl = URL.init(string: NetworkConstants.BASE_URL + NetworkConstants.ENDPOINT_SIGNUP) else {
               onCompletion(nil, UrlNotInitialized())
               return
           }
           
           let networkRequest = NetworkRequestBuilder.init(url: signupUrl)
            .addBody(requestBody: SignupRequest.init(name: name, email: email, password: password))
            .build()
           
           networkClient.makeRequest(networkRequest: networkRequest) { (data: NetworkAuthSuccessResponse?, error: Error?) in
               if let safeError = error {
                onCompletion(nil, safeError)
                   return
               }
               if let networkUserResponse = data {
                   let userEntity = UserEntity.init(
                       name: networkUserResponse.user.name,
                       email: networkUserResponse.user.email,
                       id: networkUserResponse.user._id,
                       usertoken: networkUserResponse.token)
                   onCompletion(userEntity, nil)
               }
           }
    }
    
    func logout(userAuthToken: String, onCompletion: @escaping (Error?) -> Void) {
        guard let logoutUrl = URL.init(string: NetworkConstants.BASE_URL + NetworkConstants.ENDPOINT_LOGOUT) else {
            onCompletion(UrlNotInitialized())
            return
        }
        
        let networkRequest = NetworkRequestBuilder.init(url: logoutUrl)
         .addHeader(key: userAuthToken, value: "token")
         .build()
        
        networkClient.makeRequest(networkRequest: networkRequest) { (data: NetworkAuthSuccessResponse?, error: Error?) in
            if let safeError = error {
                onCompletion(safeError)
                return
            }
            onCompletion(nil)
        }
    }
    
    
}


