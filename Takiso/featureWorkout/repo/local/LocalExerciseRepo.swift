//
//  LocalExerciseRepo.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 22/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit
import CoreData

protocol LocalExerciseRepo {
    
    func saveExerciseList(exerciseList: [Exercise])
    
    func getAllBodyParts() -> [BodyPart]
    
    func getAllEquipments() -> [Equipment]
    
    func getExercises() -> [Exercise]
}

class LocalExerciseRepoImpl : LocalExerciseRepo {
    
    private lazy var bodyPartsRepo = { return BodyPartsLocalRepo() }()
    private lazy var equipmentsRepo = { return EquipmentsLocalRepo() }()
    
    private lazy var dbContext = {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }()
    
    func getAllBodyParts() -> [BodyPart] {
        return bodyPartsRepo.getAllBodyParts()
    }
    
    func getAllEquipments() -> [Equipment] {
        return equipmentsRepo.getAllEquipments()
    }
    
    func saveExerciseList(exerciseList: [Exercise]) {
        var exerciseToBodyPartsMapping = [String: [String]]()
        var exerciseToEquipmentsMapping = [String: [String]]()
        for exercise in exerciseList {
            bodyPartsRepo.saveBodyParts(parts: exercise.bodyParts)
            equipmentsRepo.saveEquipments(parts: exercise.equipments)
            let request : NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", exercise.id)
            do {
                let result = try dbContext!.fetch(request)
                if result.isEmpty {
                    let exerciseEntity = ExerciseEntity.init(context: dbContext!)
                    exerciseEntity.id = exercise.id
                    exerciseEntity.name = exercise.name
                    try dbContext?.save()
                }} catch {
                    print(error)
            }
            exerciseToBodyPartsMapping[exercise.id] = exercise.bodyParts.map({ (part) -> String in part.id})
            exerciseToEquipmentsMapping[exercise.id] = exercise.equipments.map({ (equipment) -> String in equipment.id})
        }
        bodyPartsRepo.saveMappings(exerciseToBodyPartsMapping)
        equipmentsRepo.saveMappings(exerciseToEquipmentsMapping)
    }
        
    func getExercises() -> [Exercise] {
        // Get all the exercises
        do {
            let exerciseRequest : NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
            let exerciseEntities = try dbContext!.fetch(exerciseRequest)
            return exerciseEntities.map { (exerciseEntity) -> Exercise in
                let coveredBodyParts = bodyPartsRepo.getBodyParts(for: exerciseEntity.id!)
                let requiredEquipments = equipmentsRepo.getEquipments(for: exerciseEntity.id!)
                return Exercise.init(id: exerciseEntity.id!, name: exerciseEntity.name!,
                              bodyParts: coveredBodyParts, equipments: requiredEquipments)
            }
        } catch {
            print(error)
        }
        return []
    }
}

extension Array where Element == ExerciseEntity {
    func contains(_ target: ExerciseEntity) -> Bool {
        return contains(where: { (entity) -> Bool in
            entity.id == target.id
        })
    }
}

extension Array where Element == Exercise {
    func contains(_ target: ExerciseEntity) -> Bool {
        return contains(where: { (entity) -> Bool in
            entity.id == target.id
        })
    }
}

