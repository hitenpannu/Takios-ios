//
//  WorkoutManager.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol WorkoutManager {
    func getAllExercises(completionCallback : @escaping ([ExerciseEntity]?, TakisoException?) -> Void)
    func getAllEquipments(completionCallback :  @escaping ([EquipmentEntity]?, TakisoException?) -> Void)
    func getAllBodyParts(completionCallback: @escaping  ([BodyPartEntity]?, TakisoException?) -> Void)
}

class WorkoutManagerImpl: WorkoutManager {
    
    private let remoteExerciseRepo: RemoteExerciseRepo = RemoteExerciseRepoImpl()
    
    func getAllExercises(completionCallback:  @escaping ([ExerciseEntity]?, TakisoException?) -> Void) {
        remoteExerciseRepo.getAllExercises(completionCallback: completionCallback)
    }
    
    func getAllEquipments(completionCallback: @escaping  ([EquipmentEntity]?, TakisoException?) -> Void) {
       
    }
    
    func getAllBodyParts(completionCallback:  @escaping ([BodyPartEntity]?, TakisoException?) -> Void) {
        
    }
}
