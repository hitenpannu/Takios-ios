//
//  AuthViewModel.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 13/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

class AuthViewModel: BaseViewModel<AuthView> {
    
    enum AuthMode {
        case Signup
        case Login
    }
    
    private var currentMode : AuthMode = AuthMode.Login {
        didSet {
            updateUIForSelectedAuthMode()
        }
    }
    
    override func onViewAttached() {
        updateUIForSelectedAuthMode()
    }
    
    func toggleAuthMode(){
        switch currentMode {
        case AuthMode.Login: currentMode = AuthMode.Signup
        case AuthMode.Signup: currentMode = AuthMode.Login
        }
    }
}

//MARK: - UI Update Section

extension AuthViewModel {
    
    private func updateUIForSelectedAuthMode() {
        switch currentMode {
        case AuthMode.Signup : showUiForSignup()
        case AuthMode.Login : showUiForLogin()
        }
    }
    
    private func showUiForSignup() {
        guard let view = attachedView  else { return }
        view.updateHeadingLabelText(newText: "Start tracking your transformation journey with Takiso")
        view.updateAuthButtonTitle(newTitle: "Signup")
        view.updateAlternateAuthModeLabel(newLabel: "Already have an account?")
        view.updateAlternateAuthButtonTitle(newTitle: "Login")
        view.showHideNameField(show: true)
        
    }
    
    private func showUiForLogin() {
        guard let view = attachedView  else { return }
        view.updateHeadingLabelText(newText: "Welcome Back to Takiso")
        view.updateAuthButtonTitle(newTitle: "Login")
        view.updateAlternateAuthModeLabel(newLabel: "Don't have account?")
        view.updateAlternateAuthButtonTitle(newTitle: "Signup")
        view.showHideNameField(show: false)
    }
}

//MARK: - Handle Auth Button Click

extension AuthViewModel {
    
    func onAuthButtonClicked(name: String, email:String, password: String) {
        if(!isInputValid(name: name, email: email, password: password)) {
            return
        }
        
        let authManager = AuthModule.instance.provideAuthManager()
        
        switch currentMode {
        case AuthMode.Login: authManager.loginUser(email: email, password: password, delegate: self)
        case AuthMode.Signup: authManager.signupUser(name: name, email: email, password: password, delegate: self)
        }
    }
    
    private func isInputValid(name: String, email: String, password: String) -> Bool {
        let shouldVerifyName = currentMode == AuthMode.Signup
        let isEmailAndPasswordValid = isEmailValid(email: email) && isPasswordValid(password: password)
        if(shouldVerifyName) {
            return isNameValid(name: name) && isEmailAndPasswordValid
        }else {
            return isEmailAndPasswordValid
        }
    }
}

//MARK: - Handle Auth Callbacks

extension AuthViewModel : AuthDelegate {
    func didAuthSuccessForGuest() {
        attachedView?.authSuccess()
    }
    
    func didAuthSuccess(user: UserEntity) {
        attachedView?.authSuccess()
    }
    
    func didAuthFail(errorMessage: String) {
        attachedView?.showErrorMessage(message: errorMessage)
    }
}


//MARK: - Validation Extention

extension AuthViewModel {
    private func isNameValid(name: String) -> Bool {
        let isValid = Validator.isNameValid(name)
        if(!isValid) {
            attachedView?.showErrorMessage(message: "Please add correct name")
        }
        attachedView?.updateNameErrorStatus(showError: !isValid)
        return isValid
    }
    
    private func isEmailValid(email: String) -> Bool {
        let isValid = Validator.isEmailValid(email)
        if(!isValid) {
            attachedView?.showErrorMessage(message: "Please add correct email")
        }
        attachedView?.updateEmailErrorStatus(showError: !isValid)
        return isValid
    }
    
    private func isPasswordValid(password: String) -> Bool {
        let isValid = Validator.isPasswordValid(password)
        if(!isValid) {
            attachedView?.showErrorMessage(message: "Please add correct password")
        }
        attachedView?.updatePasswordErrorStatus(showError: !isValid)
        return isValid
    }
}
