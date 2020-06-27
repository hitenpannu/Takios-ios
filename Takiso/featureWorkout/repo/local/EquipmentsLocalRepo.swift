//
//  EquipmentsLocalRepo.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 26/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import UIKit
import CoreData

class EquipmentsLocalRepo {
    
    private lazy var dbContext = {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }()
    
    func saveEquipments(parts: [Equipment]) {
        // Get all Body parts from database
        do {
            let newEquipments = filterOutSavedEquipments(parts, getDbEntries(EquipmentEntity.fetchRequest()))
            let _ = newEquipments
                .map { (equipment) ->  EquipmentEntity in
                    let entity = EquipmentEntity.init(context: dbContext!)
                    entity.id = equipment.id
                    entity.name = equipment.name
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
            saveMapping(exerciseId: exerciseId, equipmentIds: bodyPartsId)
        }
    }
    
    private func saveMapping(exerciseId: String, equipmentIds: [String]) {
        // Check for already exiting entries
        do {
            let request : NSFetchRequest<ExerciseEquipmentEntity> = ExerciseEquipmentEntity.fetchRequest()
            let exerciseIdPredicate = NSPredicate(format: "exerciseId == %@", exerciseId)
            let equipmentsPredicate = NSPredicate(format: "equipmentId IN %@", equipmentIds)
            request.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [exerciseIdPredicate, equipmentsPredicate])
            let savedEquipments = try dbContext!.fetch(request).map({ (entity) -> String in
                entity.equipmentId!
            })
            
            let equipmentIdsToSave = equipmentIds.filter { (id) -> Bool in !savedEquipments.contains(id)}
            
            if equipmentIdsToSave.isEmpty { return }
            
            let _ = equipmentIdsToSave.map { (id) -> ExerciseEquipmentEntity in
                let entity = ExerciseEquipmentEntity.init(context: dbContext!)
                entity.equipmentId = id
                entity.exerciseId = exerciseId
                return entity
            }
            
            try dbContext!.save()
            
        } catch {
            print(error)
        }
    }
    
    func getEquipments(for exerciseId: String) -> [Equipment] {
        // Get ids of body parts linked with the exercise Id
        let bodyPartIds = getEquipmentsIdsLinkedWith(exerciseId)
        let bodyPartEntites = getEquipments(bodyPartIds)
        return bodyPartEntites.map { (entity) -> Equipment in
            Equipment.init(id: entity.id!, name: entity.name!)
        }
    }
    
    func getAllEquipments() -> [Equipment] {
        let request : NSFetchRequest<EquipmentEntity> = EquipmentEntity.fetchRequest()
        do {
            return try dbContext!.fetch(request).map({ (entity) -> Equipment in
                return Equipment.init(id: entity.id!, name: entity.name!)
            })
        } catch {
            print(error)
            return []
        }
    }
    
    func getExerciseIds(equipments: [Equipment]) -> [String] {
        let ids = equipments.map { (equipment) -> String in equipment.id }
        do {
            let request : NSFetchRequest<ExerciseEquipmentEntity> = ExerciseEquipmentEntity.fetchRequest()
            request.predicate = NSPredicate.init(format: "equipmentId IN %@", ids)
            return try dbContext!.fetch(request).map({ (entity) -> String in entity.exerciseId! })
        } catch {
            print(error)
            return []
        }
    }
}

extension EquipmentsLocalRepo {
    private func getEquipments(_ ids: [String]) -> [BodyPartEntity] {
        let request : NSFetchRequest<BodyPartEntity> = BodyPartEntity.fetchRequest()
        request.predicate = NSPredicate(format: "ANY id IN %@", ids)
        do {
            return try dbContext!.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    private func getEquipmentsIdsLinkedWith(_ exerciseId: String) -> [String] {
        let request : NSFetchRequest<ExerciseEquipmentEntity> = ExerciseEquipmentEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "exerciseId == %@", exerciseId)
        
        do {
            return try dbContext!.fetch(request)
                .map({ (entity) -> String in entity.equipmentId! })
        } catch {
            print(error)
            return []
        }
    }
    
}

extension EquipmentsLocalRepo {
    
    fileprivate func filterOutSavedEquipments(_ networkEquipments: [Equipment], _ savedEquipments: [EquipmentEntity]) -> Set<Equipment> {
        var equipmentsToSave = Set<Equipment>()
        for networkEntry in networkEquipments {
            if !savedEquipments.contains(networkEntry) {
                equipmentsToSave.insert(networkEntry)
            }
        }
        return equipmentsToSave
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


extension Array where Element == EquipmentEntity {
    func contains(_ target: Equipment) -> Bool {
        return contains(where: { (entity) -> Bool in
            entity.id == target.id
        })
    }
}


extension Array where Element == ExerciseEquipmentEntity {
    func contains(_ target: ExerciseEquipmentEntity) -> Bool {
        return contains(where: { (entity) -> Bool in
            entity.equipmentId == target.equipmentId
        })
    }
}

