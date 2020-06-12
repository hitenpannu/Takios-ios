//
//  AuthViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 12/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    enum AuthMode {
        case Signup
        case Login
    }
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var nameTextFieldWrapper: DesignableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextFieldWrapper: DesignableView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFieldWrapper: DesignableView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var alternateAuthModeLabel: UILabel!
    @IBOutlet weak var alternateAuthButton: UIButton!
    
    private var currentMode : AuthMode = AuthMode.Login {
        didSet {
            updateUIForSelectedAuthMode()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide back button
        navigationItem.hidesBackButton = true
        currentMode = AuthMode.Login
        
        // assign text delegate
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func authButtonClickHandler(_ sender: Any) {
        
    }
    
    @IBAction func alternateAuthButtonClickHandler(_ sender: Any) {
        switch currentMode {
        case AuthMode.Signup : currentMode = AuthMode.Login
        case AuthMode.Login : currentMode = AuthMode.Signup
        }
    }
    private func updateUIForSelectedAuthMode() {
        switch currentMode {
        case AuthMode.Signup : showUiForSignup()
        case AuthMode.Login : showUiForLogin()
        }
    }
    
    private func showUiForSignup() {
        headingLabel.text = "Start tracking your transformation journey with Takiso"
        
        nameTextFieldWrapper.isHidden = false
        authButton.setTitle("Signup", for: .normal)
        alternateAuthButton.setTitle("Login", for: .normal)
        alternateAuthModeLabel.text = "Already have an account?"
    }
    
    private func showUiForLogin() {
        headingLabel.text = "Welcome back to Takiso"
        
        nameTextFieldWrapper.isHidden = true
        authButton.setTitle("Login", for: .normal)
        alternateAuthButton.setTitle("Signup", for: .normal)
        alternateAuthModeLabel.text = "Don't have account?"
    }
    
}

extension AuthViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.endEditing(true)
        default:
            print("Unknown text field")
        }
        return true
    }
}
