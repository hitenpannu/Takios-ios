//
//  AuthView.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 13/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol AuthView : BaseView {
    
    func showHideNameField(show: Bool)
    
    func updateHeadingLabelText(newText: String)
    
    func updateAuthButtonTitle(newTitle: String)
    
    func updateAlternateAuthButtonTitle(newTitle: String)
    
    func updateAlternateAuthModeLabel(newLabel: String)
    
    func updateEmailErrorStatus(showError: Bool)

    func updatePasswordErrorStatus(showError: Bool)
    
    func updateNameErrorStatus(showError: Bool)
    
    func showErrorMessage(message: String)
    
    func authSuccess()
}
