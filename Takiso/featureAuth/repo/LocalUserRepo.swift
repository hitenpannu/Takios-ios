//
//  LocalUserRepo.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol LocalUserRepo {
    func isUserLoggedIn() -> Bool
    
    func isGuestLogin() -> Bool
    
    func saveUserInformation(user : UserEntity)
    
    func getUserInformation() throws -> UserEntity
    
    func clearUserInformation()
    
    func loginAsGuest()
}

class LocalUserRepoImpl: LocalUserRepo {
    
    private static let KEY_USER_ID = "KEY_USER_ID"
    private static let KEY_USER_NAME = "KEY_USER_NAME"
    private static let KEY_USER_EMAIL = "KEY_USER_EMAIL"
    private static let KEY_USER_TOKEN = "KEY_USER_TOKEN"
    private static let KEY_USER_GUEST = "KEY_IS_USER_GUEST"
    
    private var defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func isUserLoggedIn() -> Bool {
        let isUserIdPresent = defaults.string(forKey: LocalUserRepoImpl.KEY_USER_ID)
        return isUserIdPresent != nil || isGuestLogin()
    }
    
    func isGuestLogin() -> Bool {
        return defaults.bool(forKey: LocalUserRepoImpl.KEY_USER_GUEST)
    }
    
    func saveUserInformation(user: UserEntity) {
        defaults.set(user.email, forKey: LocalUserRepoImpl.KEY_USER_EMAIL)
        defaults.set(user.name, forKey: LocalUserRepoImpl.KEY_USER_NAME)
        defaults.set(user.id, forKey: LocalUserRepoImpl.KEY_USER_ID)
        defaults.set(user.usertoken, forKey: LocalUserRepoImpl.KEY_USER_TOKEN)
        defaults.set(false, forKey: LocalUserRepoImpl.KEY_USER_GUEST)
    }
    
    func getUserInformation() throws -> UserEntity {
        return UserEntity(
            name: defaults.string(forKey: LocalUserRepoImpl.KEY_USER_NAME) ?? "",
            email: defaults.string(forKey: LocalUserRepoImpl.KEY_USER_EMAIL) ?? "" ,
            id: defaults.string(forKey: LocalUserRepoImpl.KEY_USER_ID) ?? "" ,
            usertoken: defaults.string(forKey: LocalUserRepoImpl.KEY_USER_TOKEN) ?? "")
    }
    
    func clearUserInformation() {
        defaults.removeObject(forKey: LocalUserRepoImpl.KEY_USER_ID)
        defaults.removeObject(forKey: LocalUserRepoImpl.KEY_USER_NAME)
        defaults.removeObject(forKey: LocalUserRepoImpl.KEY_USER_EMAIL)
        defaults.removeObject(forKey: LocalUserRepoImpl.KEY_USER_TOKEN)
        defaults.removeObject(forKey: LocalUserRepoImpl.KEY_USER_GUEST)
    }
    
    func loginAsGuest() {
        let newUserID = UUID().uuidString
        defaults.set(newUserID, forKey: LocalUserRepoImpl.KEY_USER_ID)
        defaults.set(true, forKey: LocalUserRepoImpl.KEY_USER_GUEST)
    }
    
    
}


