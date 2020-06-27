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
    
    func getAllExercises(forcedFresh: Bool, completionCallback : @escaping ([Exercise]?, TakisoException?) -> Void)
    
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
        print("Requesting new Exercise List")
    }
    
    func getAllExercises(forcedFresh: Bool, completionCallback:  @escaping ([Exercise]?, TakisoException?) -> Void) {
        if forcedFresh {
            self.updateLocalRepo { (exerciseList, error) in
                if let safeError = error {
                    completionCallback(nil, safeError)
                    return
                }
                completionCallback(exerciseList, nil)
            }
        }else {
            self.getFromLocal(completionCallback)
        }
    }
        
    private func updateLocalRepo(_ completionCallback: @escaping ([Exercise]?, TakisoException?)-> Void) {
        remoteExerciseRepo.getAllExercises { (exerciseList, exception) in
            if let safeError = exception {
                completionCallback(nil, safeError)
                return
            }
            
            if let safeExerciseList = exerciseList {
             self.localExerciseRepo.saveExerciseList(exerciseList: safeExerciseList)
            }
            completionCallback(exerciseList, nil)
        }
    }
    
    private func getFromLocal(_ completionCallback: @escaping ([Exercise]?, TakisoException?)-> Void) {
        let exercise = localExerciseRepo.getExercises()
        if !exercise.isEmpty {
            completionCallback(exercise, nil)
            return
        }
        remoteExerciseRepo.getAllExercises { (exerciseList, exception) in
            if let safeError = exception {
                completionCallback(nil, safeError)
                return
            }
            
            if let safeExerciseList = exerciseList {
             self.localExerciseRepo.saveExerciseList(exerciseList: safeExerciseList)
            }
            
            let updated = self.localExerciseRepo.getExercises()
            completionCallback(updated, nil)
        }
    }
}
