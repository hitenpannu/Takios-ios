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
    
    func getExercises(ids :[String]) -> [Exercise]
    
    func getExercises(bodyParts: [BodyPart], equipments: [Equipment]) -> [Exercise]
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
        return getExercises(ids: [])
    }
    
    func getExercises(ids :[String] = []) -> [Exercise] {
        // Get all the exercises
        do {
            let exerciseRequest : NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
            if !ids.isEmpty {
                exerciseRequest.predicate = NSPredicate.init(format: "id IN %@", ids)
            }
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
    
    func getExercises(bodyParts: [BodyPart], equipments: [Equipment]) -> [Exercise] {
        // Get Exercises for bodyParts
        if !bodyParts.isEmpty {
          let exerciseIds = bodyPartsRepo.getExerciseIds(bodyParts: bodyParts)
          var exercises = getExercises(ids: exerciseIds)
          
          // Filters fetched exercises for requestes equipments
          if !equipments.isEmpty {
              exercises = exercises.filter({ (exercise) -> Bool in
                  exercise.equipments.contains { (equipment) -> Bool in equipments.contains(equipment)}
              })
          }
          return exercises
        } else if !equipments.isEmpty{
          let exerciseIds = equipmentsRepo.getExerciseIds(equipments: equipments)
          return getExercises(ids: exerciseIds)
        } else {
            return getExercises()
        }
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

