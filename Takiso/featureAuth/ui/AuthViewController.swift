//
//  AuthViewController.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 12/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
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
    
    private var authViewModel : AuthViewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide back button
        navigationItem.hidesBackButton = true
        
        // assign text delegate
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        authViewModel.attachView(view: self)
    }
    
    @IBAction func authButtonClickHandler(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        authViewModel.onAuthButtonClicked(name: name, email: email, password: password)
    }
    
    @IBAction func alternateAuthButtonClickHandler(_ sender: Any) {
        authViewModel.toggleAuthMode()
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

//MARK: - Handle View Callbacks from viewModel

extension AuthViewController : AuthView {
    
    func showHideNameField(show: Bool){
        nameTextFieldWrapper.isHidden = !show
    }
    
    func updateHeadingLabelText(newText: String) {
        headingLabel.text = newText
    }
    
    func updateAuthButtonTitle(newTitle: String){
        authButton.setTitle(newTitle, for: .normal)
    }
    
    func updateAlternateAuthButtonTitle(newTitle: String) {
        alternateAuthButton.setTitle(newTitle, for: .normal)
    }
    
    func updateAlternateAuthModeLabel(newLabel: String){
        alternateAuthModeLabel.text = newLabel
    }
    
    func updateEmailErrorStatus(showError: Bool) {
        if showError { emailTextField.becomeFirstResponder() }
        emailTextFieldWrapper.layer.shadowColor = showError ? UIColor.red.cgColor : UIColor.init(named: "charcoal")?.cgColor
    }
    
    func updatePasswordErrorStatus(showError: Bool) {
        if showError { passwordTextField.becomeFirstResponder() }
        passwordTextFieldWrapper.layer.shadowColor = showError ? UIColor.red.cgColor :  UIColor.init(named: "charcoal")?.cgColor
    }
    
    func updateNameErrorStatus(showError: Bool) {
        if showError { nameTextField.becomeFirstResponder() }
        nameTextFieldWrapper.layer.shadowColor = showError ? UIColor.red.cgColor :  UIColor.init(named: "charcoal")?.cgColor
    }
    
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController.init(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            
            let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
            
            alertViewController.addAction(dismissAction)
            
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func authSuccess() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
