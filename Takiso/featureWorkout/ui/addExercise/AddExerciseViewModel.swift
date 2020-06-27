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
    private var indexesOfSelectedExercises = Set<Int>()
    
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
    
    func getTotalNumberOfFilters() -> Int {
        if let currentFilter = workoutManager.getCurrentFilters() {
            return currentFilter.bodyParts.count + currentFilter.equipments.count
        } else {
          return 0
        }
    }
    
    func toggleSelection(index: Int) {
        if indexesOfSelectedExercises.contains(index) {
            indexesOfSelectedExercises.remove(index)
        } else {
            indexesOfSelectedExercises.insert(index)
        }
    }
    
    func isSelected(index: Int) -> Bool {
        return indexesOfSelectedExercises.contains(index)
    }
}

extension AddExerciseViewModel : WorkoutManagerDelegate {
    func updateExerciseList(newExerciseList: [Exercise]) {
        self.exerciseList = newExerciseList
        self.attachedView?.refreshExerciseList()
    }
}
