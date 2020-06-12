//
//  NetworkAuthSuccessResponse.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation


struct NetworkUser : Decodable{
    let _id: String
    let name: String
    let email: String
}

struct NetworkAuthSuccessResponse: Decodable {
    let user: NetworkUser
    let token: String
}

struct LoginRequest : Encodable {
    let email: String
    let password: String
}

struct SignupRequest : Encodable {
    let name: String
    let email: String
    let password: String
}
