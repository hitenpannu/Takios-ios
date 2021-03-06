//
//  Validator.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 13/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

struct Validator {
    
    private static let MIN_PASSWRD_LENGTH = 6
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isNameValid(_ name: String) -> Bool {
        return !name.isEmpty
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        return password.count > Validator.MIN_PASSWRD_LENGTH
    }
 }
