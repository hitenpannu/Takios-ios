//
//  BodyPartsLocalRepo.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 26/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit
import CoreData

class BodyPartsLocalRepo {
    
    private lazy var dbContext = {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }()
    
    func saveBodyParts(parts: [BodyPart]) {
        // Get all Body parts from database
        do {
            let newBodyParts = filterOutSavedBodyParts(parts, getDbEntries(BodyPartEntity.fetchRequest()))
            let _ = newBodyParts
                .map { (bodyPart) -> BodyPartEntity in
                    let entity = BodyPartEntity.init(context: dbContext!)
                    entity.id = bodyPart.id
                    entity.name = bodyPart.name
                    return entity
            }
            try dbContext?.save()
        } catch {
            print(error)
        }
    }
    
    func saveMappings(_ mapping : [String: [String]]) {
        if mapping.isEmpty { return }
        for entry in mapping {
            let exerciseId = entry.key
            let bodyPartsId = entry.value
            saveMapping(exerciseId: exerciseId, bodyPartIds: bodyPartsId)
        }
    }
    
    private func saveMapping(exerciseId: String, bodyPartIds: [String]) {
        // Check for already exiting entries
        do {
            let request : NSFetchRequest<ExerciseBodyPartEntity> = ExerciseBodyPartEntity.fetchRequest()
            let exerciseIdPredicate = NSPredicate(format: "exerciseId == %@", exerciseId)
            let bodyPartsPredicate = NSPredicate(format: "bodyPartId IN %@", bodyPartIds)
            request.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [exerciseIdPredicate, bodyPartsPredicate])
            let savedBodyParts = try dbContext!.fetch(request).map({ (entity) -> String in
                entity.bodyPartId!
            })
            
            let bodyPartToSave = bodyPartIds.filter { (id) -> Bool in !savedBodyParts.contains(id)}
            
            if bodyPartToSave.isEmpty { return }
            
            let _ = bodyPartToSave.map { (id) -> ExerciseBodyPartEntity in
                let entity = ExerciseBodyPartEntity.init(context: dbContext!)
                entity.bodyPartId = id
                entity.exerciseId = exerciseId
                return entity
            }
            
            try dbContext!.save()
        
        } catch {
            print(error)
        }
    }
    
    func getBodyParts(for exerciseId: String) -> [BodyPart] {
        // Get ids of body parts linked with the exercise Id
        let bodyPartIds = getBodyPartIdsLinkedWith(exerciseId)
        let bodyPartEntites = getBodyParts(bodyPartIds)
        return bodyPartEntites.map { (entity) -> BodyPart in
            BodyPart.init(id: entity.id!, name: entity.name!)
        }
    }
}

extension BodyPartsLocalRepo {
    private func getBodyParts(_ ids: [String]) -> [BodyPartEntity] {
        let request : NSFetchRequest<BodyPartEntity> = BodyPartEntity.fetchRequest()
        request.predicate = NSPredicate(format: "ANY id IN %@", ids)
        do {
            return try dbContext!.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    private func getBodyPartIdsLinkedWith(_ exerciseId: String) -> [String] {
        let request : NSFetchRequest<ExerciseBodyPartEntity> = ExerciseBodyPartEntity.fetchRequest()
    
        request.predicate = NSPredicate(format: "exerciseId == %@", exerciseId)
        
        do {
            return try dbContext!.fetch(request)
                .map({ (entity) -> String in entity.bodyPartId! })
        } catch {
            print(error)
            return []
        }
    }
}

extension BodyPartsLocalRepo {
    
    fileprivate func filterOutSavedBodyParts(_ networkBodyParts: [BodyPart], _ savedBodyParts: [BodyPartEntity]) -> Set<BodyPart> {
        var bodyPartsToSave = Set<BodyPart>()
        for networkEntry in networkBodyParts {
            if !savedBodyParts.contains(networkEntry) {
                bodyPartsToSave.insert(networkEntry)
            }
        }
        return bodyPartsToSave
    }
    
    func getDbEntries<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try dbContext!.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
}


extension Array where Element == BodyPartEntity {
    func contains(_ target: BodyPart) -> Bool {
        return contains(where: { (entity) -> Bool in
            entity.id == target.id
        })
    }
}


extension Array where Element == ExerciseBodyPartEntity {
    func contains(_ target: ExerciseBodyPartEntity) -> Bool {
        return contains(where: { (entity) -> Bool in
            entity.bodyPartId == target.bodyPartId
        })
    }
}

