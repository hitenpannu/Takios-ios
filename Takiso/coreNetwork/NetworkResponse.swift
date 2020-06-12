//
//  NetworkResponse.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

struct Status : Decodable {
    let code: Int
    let message: String
}

struct NetworkResponse<T: Decodable> : Decodable {
    let status: Status
    let data : T? = nil
}

