//
//  AddExerciseViewModel.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

class AddExerciseViewModel: BaseViewModel<AddExerciseView> {
    
    private let workoutManager : WorkoutManager = WorkoutManagerImpl()
    private var exerciseList = [Exercise]()
    
    override func onViewAttached() {
        loadAllExercises()
    }
    
    func getExerciseCount() -> Int {
        return exerciseList.count
    }
    
    func getExerciseAt(position: Int) -> Exercise? {
        if position > exerciseList.count { return nil }
        return exerciseList[position]
    }
    
    func loadAllExercises() {
        workoutManager.getAllExercises { (exerciseList, exception) in
            if let safeError = exception {
                self.attachedView?.showErrorMessage(message: safeError.message)
                return
            }
            
            if let exercises = exerciseList {
                self.exerciseList = exercises
                self.attachedView?.refreshExerciseList()
            }
        }
    }
    
}
