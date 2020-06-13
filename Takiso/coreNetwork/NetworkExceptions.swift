//
//  NetworkExceptions.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 13/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol TakisoException: Error {
    var message: String { get }
}

struct ServerError : TakisoException {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
