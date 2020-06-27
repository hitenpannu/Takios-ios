//
//  AddExerciseView.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol AddExerciseView: BaseView {
    
    func refreshExerciseList()
    
    func showErrorMessage(message: String)
    
}
