//
//  ViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 7/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var authManager = AuthModule.instance.provideAuthManager()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !authManager.isUserLoggedIn() {
            print("User is not Logged IN")
            performSegue(withIdentifier: "goToDashboard", sender: self)
            return
        }
           print("User is Logged IN")
    }
}

