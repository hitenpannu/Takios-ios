//
//  ExtentionUiViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String) {
        let alertViewController = UIAlertController.init(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        
        alertViewController.addAction(dismissAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
}


