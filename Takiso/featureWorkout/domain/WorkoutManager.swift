//
//  WorkoutManager.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

struct Filters {
    var bodyParts: [BodyPart]
    var equipments: [Equipment]
}

protocol WorkoutManagerDelegate {
    func updateExerciseList(newExerciseList: [Exercise])
}

protocol WorkoutManager {
    
    func attachDelegate(delegate: WorkoutManagerDelegate)
    
    func getAllExercises(forcedFresh: Bool)
    
    func getAllBodyParts(completionCallback : @escaping ([BodyPart]?, TakisoException?) -> Void)
    
    func getAllEquipments(completionCallback : @escaping ([Equipment]?, TakisoException?) -> Void)
    
    func applyFilters(bodyParts: [BodyPart], equipments : [Equipment])
    
    func getCurrentFilters() -> Filters?
}

class WorkoutManagerImpl: WorkoutManager {

    private static var instance : WorkoutManagerImpl? = nil
    
    static func getInstance() -> WorkoutManager {
        if instance == nil {
            instance = WorkoutManagerImpl.init()
        }
        return instance!
    }
    
    private let remoteExerciseRepo: RemoteExerciseRepo
    private let localExerciseRepo : LocalExerciseRepo
    private var workoutManagerDelegate: WorkoutManagerDelegate? = nil
    private var filters : Filters? = nil {
        didSet {
            updateExerciseList()
        }
    }
    
    init(localExerciseRepo : LocalExerciseRepo = LocalExerciseRepoImpl(), remoteExerciseRepo: RemoteExerciseRepo = RemoteExerciseRepoImpl()) {
        self.localExerciseRepo = localExerciseRepo
        self.remoteExerciseRepo = remoteExerciseRepo
    }
    
    func attachDelegate(delegate: WorkoutManagerDelegate) {
        self.workoutManagerDelegate = delegate
    }
    
    func getCurrentFilters() -> Filters? {
        return filters
    }
    
    func getAllBodyParts(completionCallback : @escaping ([BodyPart]?, TakisoException?) -> Void) {
        let bodyParts = localExerciseRepo.getAllBodyParts()
        completionCallback(bodyParts, nil)
    }
    
    func getAllEquipments(completionCallback : @escaping ([Equipment]?, TakisoException?) -> Void) {
        let equipments = localExerciseRepo.getAllEquipments()
        completionCallback(equipments, nil)
    }
    
    func applyFilters(bodyParts: [BodyPart], equipments: [Equipment]) {
        self.filters = Filters.init(bodyParts: bodyParts, equipments: equipments)
    }
    
    func updateExerciseList() {
        // Fetch the exercise list with the filters and call the delegate
        if let safeFilters = filters {
            let filteredList = localExerciseRepo.getExercises(bodyParts: safeFilters.bodyParts, equipments: safeFilters.equipments)
            self.workoutManagerDelegate?.updateExerciseList(newExerciseList: filteredList)
        } else {
            let allExercises = self.localExerciseRepo.getExercises()
            if allExercises.isEmpty {
                // need to fetch from remote as db is empty
                getFromRemote {
                    self.workoutManagerDelegate?.updateExerciseList(newExerciseList: self.localExerciseRepo.getExercises())
                }
            } else {
                self.workoutManagerDelegate?.updateExerciseList(newExerciseList: allExercises)
            }
        }
    }
    
    func getAllExercises(forcedFresh: Bool) {
        if forcedFresh {
            self.updateLocalRepo()
        } else {
          updateExerciseList()
        }
    }
        
    private func updateLocalRepo() {
        remoteExerciseRepo.getAllExercises { (exerciseList, exception) in
            if let safeError = exception {
                print(safeError)
                return
            }
            
            if let safeExerciseList = exerciseList {
             self.localExerciseRepo.saveExerciseList(exerciseList: safeExerciseList)
            }
            self.updateExerciseList()
        }
    }
    
    private func getFromRemote(_ completionCallback: @escaping () -> Void) {
        remoteExerciseRepo.getAllExercises { (exerciseList, exception) in
            if let safeError = exception {
                print(safeError)
                return
            }
            
            if let safeExerciseList = exerciseList {
             self.localExerciseRepo.saveExerciseList(exerciseList: safeExerciseList)
            }
            completionCallback()
        }
    }
}
