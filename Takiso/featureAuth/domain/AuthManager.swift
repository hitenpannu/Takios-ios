//
//  AuthManager.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

protocol AuthDelegate {
    func didAuthSuccessForGuest()
    func didAuthSuccess(user : UserEntity)
    func didAuthFail(errorMessage: String)
}

protocol AuthManager {
    
    func isUserLoggedIn() -> Bool
    
    func isGuestUser () -> Bool
    
    func getCurrentUser() -> UserEntity
    
    func loginUser(email: String, password: String, delegate: AuthDelegate?)
    
    func signupUser(name: String, email: String, password: String, delegate: AuthDelegate?)
    
    func loginAsGuest(delegate: AuthDelegate)
    
    func logout(completion: @escaping() -> Void)
}

class AuthManagerImpl: AuthManager {
    
    
    private var localUserRepo : LocalUserRepo
    private var remoteUserRepo : RemoteUserRepo
    
    init(localRepo: LocalUserRepo, remoteRepo: RemoteUserRepo) {
        self.localUserRepo = localRepo
        self.remoteUserRepo = remoteRepo
    }
    
    func isUserLoggedIn() -> Bool {
        return localUserRepo.isUserLoggedIn() || localUserRepo.isGuestLogin()
    }
    
    func isGuestUser() -> Bool {
        return localUserRepo.isGuestLogin()
    }
    
    func getCurrentUser() -> UserEntity {
        do {
            return try localUserRepo.getUserInformation()
        } catch {
            fatalError("User Not logged in")
        }
    }
    
    func loginUser(email: String, password: String, delegate: AuthDelegate?) {
        remoteUserRepo.loginUser(email: email, password: password) { (user, error) in
            if let safeError = error {
                delegate?.didAuthFail(errorMessage: safeError.localizedDescription)
                return
            }
            
            if let safeUser = user {
                self.localUserRepo.saveUserInformation(user: safeUser)
                delegate?.didAuthSuccess(user: safeUser)
            }
        }
    }
    
    func signupUser(name: String, email: String, password: String, delegate: AuthDelegate?) {
        remoteUserRepo.signupUser(name: name, email: email, password: password) { (user, error) in
            if let safeError = error {
                delegate?.didAuthFail(errorMessage: safeError.localizedDescription)
                return
            }
            
            if let safeUser = user {
                self.localUserRepo.saveUserInformation(user: safeUser)
                delegate?.didAuthSuccess(user: safeUser)
            }
        }
    }
    
    func loginAsGuest(delegate: AuthDelegate) {
        localUserRepo.loginAsGuest()
        delegate.didAuthSuccessForGuest()
    }
    
    func logout(completion: @escaping ()-> Void){
        do {
            let userAuthToken = try localUserRepo.getUserInformation().usertoken
            remoteUserRepo.logout(userAuthToken: userAuthToken) { (error) in
                self.localUserRepo.clearUserInformation()
                if let safeError = error {
                    print(safeError)
                }
                completion()
            }
        } catch {
            print(error)
        }
    }
}
