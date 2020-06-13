//
//  ViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Segue {
        static let GoToAuthFlow = "goToAuthFlow"
        static let GoToDashbaord = "goToDashboard"
    }
    
    private var authManager = AuthModule.instance.provideAuthManager()
    
    override func viewDidLoad() {
         // hide back button
         navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !authManager.isUserLoggedIn() {
            print("User is not Logged IN")
            performSegue(withIdentifier: Segue.GoToAuthFlow, sender: self)
            return
        } else {
            performSegue(withIdentifier: Segue.GoToDashbaord, sender: self)
        }
    }
}

