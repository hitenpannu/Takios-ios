//
//  DashboardViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    private struct Segue {
        static let GO_TO_ADD_EXERCISE = "goToAddExercise"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Dashboard"
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCreateWorkoutClicked(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.GO_TO_ADD_EXERCISE, sender: self)
    }
}
