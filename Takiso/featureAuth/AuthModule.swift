//
//  AuthModule.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

class AuthModule {
    
    private init() {}
    
    static let instance : AuthModule = AuthModule()
    
    private var objectDictionary : [String : Any] = [:]
    
    func provideLocalRepo() -> LocalUserRepo {
        var fromDictionary = objectDictionary["LocalUserRepo"]
        if(fromDictionary == nil) {
            fromDictionary = LocalUserRepoImpl(defaults: UserDefaults.standard)
            objectDictionary["LocalUserRepo"] = fromDictionary
        }
        return fromDictionary as! LocalUserRepo
    }
    
    func provideRemoteUserRepo() -> RemoteUserRepo {
        var fromDictionary = objectDictionary["RemoteUserRepo"]
        if(fromDictionary == nil) {
            fromDictionary = RemoteUserRepoImpl()
            objectDictionary["RemoteUserRepo"] = fromDictionary
        }
        return fromDictionary as! RemoteUserRepo
    }
    
    func provideAuthManager() -> AuthManager {
        var fromDictionary = objectDictionary["AuthManager"]
        if(fromDictionary == nil) {
            fromDictionary = AuthManagerImpl(localRepo: provideLocalRepo(), remoteRepo: provideRemoteUserRepo())
            objectDictionary["AuthManager.Protocol"] = fromDictionary
        }
        return fromDictionary as! AuthManager
    }
}
