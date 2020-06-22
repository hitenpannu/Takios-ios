//
//  RemoteExerciseRepo.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

protocol RemoteExerciseRepo {
    func getAllExercises(completionCallback : @escaping ([Exercise]?, TakisoException?) -> Void)
}

class RemoteExerciseRepoImpl : RemoteExerciseRepo {
    
    let networkClient = NetworkClientImpl()
    
    func getAllExercises(completionCallback: @escaping ([Exercise]?, TakisoException?) -> Void) {
        guard let exerciseUrl = URL.init(string: NetworkConstants.BASE_URL + NetworkConstants.ENDPOINT_EXERCISE) else {
            completionCallback(nil, UrlNotInitialized())
            return
        }
        
        let exerciseRequest = NetworkRequestBuilder.init(url: exerciseUrl)
            .useMethod(method: .GET)
            .build()
        
        networkClient.makeRequest(networkRequest: exerciseRequest) { (data:ExerciseNetworkResponse?, error: TakisoException?) in
            
            if let safeError = error {
                completionCallback(nil, safeError)
                return
            }
            
            if let networkResponse = data?.data {
                var exercises = [Exercise]()
                
                for networkExercise in networkResponse {
                    var bodyParts = [BodyPart]()
                    for networkBodyPart in networkExercise.bodyParts {
                        let bodyPartEntity = BodyPart.init(id: networkBodyPart._id, name: networkBodyPart.name)
                        bodyParts.append(bodyPartEntity)
                    }
                    var equipments = [Equipment]()
                    for networkEquipment in networkExercise.equipments {
                        let equipment = Equipment.init(id: networkEquipment._id, name: networkEquipment.name)
                        equipments.append(equipment)
                    }
                    let exercise = Exercise.init(id: networkExercise._id, name: networkExercise.name, bodyParts: bodyParts, equipments: equipments)
                    exercises.append(exercise)
                }
                
                completionCallback(exercises, nil)
            }
            
        }
        
    }
}
