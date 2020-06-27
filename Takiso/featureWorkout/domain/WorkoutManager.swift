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
