//
//  WorkoutManager.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol WorkoutManager {
    func getAllExercises(forcedFresh: Bool, completionCallback : @escaping ([Exercise]?, TakisoException?) -> Void)
    func getAllEquipments(completionCallback :  @escaping ([Equipment]?, TakisoException?) -> Void)
    func getAllBodyParts(completionCallback: @escaping  ([BodyPart]?, TakisoException?) -> Void)
}

class WorkoutManagerImpl: WorkoutManager {
    
    private let remoteExerciseRepo: RemoteExerciseRepo
    private let localExerciseRepo : LocalExerciseRepo
    
    init(localExerciseRepo : LocalExerciseRepo = LocalExerciseRepoImpl(), remoteExerciseRepo: RemoteExerciseRepo = RemoteExerciseRepoImpl()) {
        self.localExerciseRepo = localExerciseRepo
        self.remoteExerciseRepo = remoteExerciseRepo
    }
    
    func getAllExercises(forcedFresh: Bool, completionCallback:  @escaping ([Exercise]?, TakisoException?) -> Void) {
        if forcedFresh {
            self.updateLocalRepo { (exerciseList, error) in
                if let safeError = error {
                    completionCallback(nil, safeError)
                    return
                }
                self.getFromLocal(completionCallback)
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
        }
    }
    
    private func getFromLocal(_ completionCallback: @escaping ([Exercise]?, TakisoException?)-> Void) {
        let exercise = localExerciseRepo.getExercise(bodyParts: [], equipments: [])
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
            
            let updated = self.localExerciseRepo.getExercise(bodyParts: [], equipments: [])
            completionCallback(updated, nil)
        }
    }
    
    func getAllEquipments(completionCallback: @escaping  ([Equipment]?, TakisoException?) -> Void) {
        let equipments = localExerciseRepo.getAllEquipments(ids: [])
        completionCallback(equipments, nil)
    }
    
    func getAllBodyParts(completionCallback:  @escaping ([BodyPart]?, TakisoException?) -> Void) {
        let bodyParts = localExerciseRepo.getAllBodyParts(ids: [])
        completionCallback(bodyParts, nil)
    }
}
