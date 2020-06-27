//
//  AddExerciseViewModel.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

class AddExerciseViewModel: BaseViewModel<AddExerciseView> {
    
    private let workoutManager : WorkoutManager = WorkoutManagerImpl.getInstance()
    private var exerciseList = [Exercise]()
    
    override func onViewAttached() {
        workoutManager.attachDelegate(delegate: self)
        loadAllExercises(forcedFresh: false)
    }
    
    func getExerciseCount() -> Int {
        return exerciseList.count
    }
    
    func getExerciseAt(position: Int) -> Exercise? {
        if position > exerciseList.count { return nil }
        return exerciseList[position]
    }
    
    @objc func loadAllExercises(forcedFresh: Bool) {
        workoutManager.getAllExercises(forcedFresh: forcedFresh)
    }
    
}

extension AddExerciseViewModel : WorkoutManagerDelegate {
    func updateExerciseList(newExerciseList: [Exercise]) {
        self.exerciseList = newExerciseList
        self.attachedView?.refreshExerciseList()
    }
}
