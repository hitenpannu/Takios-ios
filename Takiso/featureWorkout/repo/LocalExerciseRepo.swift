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
    
    func getExercise(bodyParts : [BodyPart], equipments: [Equipment]) -> [Exercise]
    
    func getAllBodyParts(ids: [String]) -> [BodyPart]
    
    func getAllEquipments(ids: [String]) -> [Equipment]
}

class LocalExerciseRepoImpl : LocalExerciseRepo {
    
    private lazy var dbContext = {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }()
    
    func saveExerciseList(exerciseList: [Exercise]) {
        var bodyPartsSet = Set<String>()
        for exercise in exerciseList {
            // Save the body parts
            for bodyPart in exercise.bodyParts {
                if(!bodyPartsSet.contains(bodyPart.id)) {
                    let entity = BodyPartEntity.init(context: dbContext!)
                    entity.id = bodyPart.id
                    entity.name = bodyPart.name
                    bodyPartsSet.insert(bodyPart.id)
                }
                
                let exerciseWithBodyPart = ExerciseBodyPartEntity.init(context: dbContext!)
                exerciseWithBodyPart.exerciseId = exercise.id
                exerciseWithBodyPart.bodyPartId = bodyPart.id
            }
            
            // Save the equipments
            var equipmentSet = Set<String>()
            for equipment in exercise.equipments{
                if(!equipmentSet.contains(equipment.id)) {
                    let entity = EquipmentEntity.init(context: dbContext!)
                    entity.id = equipment.id
                    entity.name = equipment.name
                    equipmentSet.insert(equipment.id)
                }
                
                let exerciseWithEquipment = ExerciseEquipmentEntity.init(context: dbContext!)
                exerciseWithEquipment.exerciseId = exercise.id
                exerciseWithEquipment.equipmentId = equipment.id
            }
        }
        
        do {
            try dbContext!.save()
        } catch {
            print(error)
        }
    }
    
    func getExercise(bodyParts: [BodyPart] = [], equipments: [Equipment] = []) -> [Exercise] {
        var listOfExerciseIdFromBodyParts = Set<String>()
        if(!bodyParts.isEmpty) {
            let listOfBodyPartIds = bodyParts.map({ (part) -> String in part.id})
            let fetchRequest : NSFetchRequest<ExerciseBodyPartEntity> = ExerciseBodyPartEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "ANY bodyPartId IN @a", listOfBodyPartIds)
            
            do {
                let result = try dbContext!.fetch(fetchRequest)
                for item in result {
                    if let exerciseId = item.exerciseId {
                        listOfExerciseIdFromBodyParts.insert(exerciseId)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        var listOfExerciseIdFromEquipments = Set<String>()
        if(!equipments.isEmpty) {
            let fetchRequest : NSFetchRequest<ExerciseEquipmentEntity> = ExerciseEquipmentEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "ANY equipmentId IN @", equipments.map({ (equipment) -> String in equipment.id }))
            do {
                let result = try dbContext!.fetch(fetchRequest)
                for item in result {
                    if let exerciseId = item.exerciseId {
                        listOfExerciseIdFromEquipments.insert(exerciseId)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        var finalListOFExercise = Set<String>()
        if(!bodyParts.isEmpty && equipments.isEmpty) {
            finalListOFExercise = listOfExerciseIdFromBodyParts
        }else if bodyParts.isEmpty && !equipments.isEmpty {
            finalListOFExercise = listOfExerciseIdFromEquipments
        }else if !bodyParts.isEmpty && !equipments.isEmpty {
            finalListOFExercise = listOfExerciseIdFromBodyParts.union(listOfExerciseIdFromEquipments)
        }
        
        let exerciseRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        if(!finalListOFExercise.isEmpty)
        {
            exerciseRequest.predicate  = NSPredicate.init(format: "ANY id IN @", finalListOFExercise)
        }
        
        do {
            let exerciseEntities = try dbContext!.fetch(exerciseRequest)
            var exerciseResult = [Exercise]()
            for exerciseEntity in exerciseEntities {
                let bodyParts = getAllBodyPartsIdFor(exerciseId: exerciseEntity.id!)
                let equipments = getAllEquipmentsIdFor(exerciseId: exerciseEntity.id!)
                let exercise = Exercise.init(
                    id: exerciseEntity.id!,
                    name: exerciseEntity.name!,
                    bodyParts: getAllBodyParts(ids: bodyParts),
                    equipments: getAllEquipments(ids: equipments))
                exerciseResult.append(exercise)
            }
            return exerciseResult
        } catch {
            print(error)
        }
        return []
    }
    
    private func getAllBodyPartsIdFor(exerciseId: String) -> [String] {
        let request : NSFetchRequest<ExerciseBodyPartEntity> = ExerciseBodyPartEntity.fetchRequest()
        request.predicate = NSPredicate.init(format: "exerciseId == @", exerciseId)
        do {
            return try dbContext!.fetch(request).map({ (entity) -> String in
                return entity.exerciseId!
            })
        } catch {
            print(error)
            return []
        }
    }
    
    private func getAllEquipmentsIdFor(exerciseId: String) -> [String] {
        let request : NSFetchRequest<ExerciseEquipmentEntity> = ExerciseEquipmentEntity.fetchRequest()
        request.predicate = NSPredicate.init(format: "exerciseId == @", exerciseId)
        do {
            return try dbContext!.fetch(request).map({ (entity) -> String in return entity.exerciseId! })
        } catch {
            print(error)
            return []
        }
    }
        
    func getAllBodyParts(ids: [String] = []) -> [BodyPart] {
        let request : NSFetchRequest<BodyPartEntity> = BodyPartEntity.fetchRequest()
        if(!ids.isEmpty) {
            request.predicate = NSPredicate.init(format: "ANY id IN @", ids)
        }
        do {
            return try dbContext!.fetch(request).map({ (entity) -> BodyPart in
                BodyPart.init(id: entity.id!, name: entity.name!)
            })
        } catch {
            print(error)
            return []
        }
    }
    
    func getAllEquipments(ids : [String] = []) -> [Equipment] {
        let request : NSFetchRequest<EquipmentEntity> = EquipmentEntity.fetchRequest()
        if(!ids.isEmpty) {
            request.predicate = NSPredicate.init(format: "ANY id IN @", ids)
        }
        do {
            return try dbContext!.fetch(request).map({ (entity) -> Equipment in
                Equipment.init(id: entity.id!, name: entity.name!)
            })
        } catch {
            print(error)
            return []
        }
    }
    
}
