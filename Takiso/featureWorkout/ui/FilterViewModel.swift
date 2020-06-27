//
//  FilterViewModel.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 27/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

class FilterViewModel: BaseViewModel<FilterView> {

    private let workoutManager : WorkoutManager = WorkoutManagerImpl.getInstance()
    
    private var bodyParts = [BodyPart]()
    private var equipments = [Equipment]()
    
    private var selectedBodyParts = [BodyPart]()
    private var selectedEquipments = [Equipment]()
    
    func totalNumberOfBodyParts() -> Int {
        return bodyParts.count
    }
    
    func totalNumberOfEquipments() -> Int {
        return equipments.count
    }
    
    func getBodyPart(at index: Int) -> BodyPart {
        return bodyParts[index]
    }
    
    func getEquipment(at index: Int) -> Equipment {
        return equipments[index]
    }
    
    func loadAvailableFilters() {
        workoutManager.getAllBodyParts { (bodyParts, exception) in
            self.bodyParts = bodyParts ?? []
            self.attachedView?.updateBodyParts()
        }
        
        workoutManager.getAllEquipments { (equipments, exception) in
            self.equipments = equipments ?? []
            self.attachedView?.updateEquipments()
        }
        
        if let currentFilters = workoutManager.getCurrentFilters() {
            selectedBodyParts = currentFilters.bodyParts
            selectedEquipments = currentFilters.equipments
        }
    }
    
    func isSelected(bodyPart: BodyPart) -> Bool {
        return selectedBodyParts.contains(bodyPart)
    }
    
    func isSelected(equipment: Equipment) -> Bool {
        return selectedEquipments.contains(equipment)
    }
    
    func toggleBodyPart(index: Int) {
        let item = bodyParts[index]
        if !selectedBodyParts.contains(item) {
            selectedBodyParts.append(item)
        } else {
            if let index = selectedBodyParts.firstIndex(of: item) {
              selectedBodyParts.remove(at: index)
            }
        }
    }
    
    func toggleEquipment(index: Int) {
        let item = equipments[index]
        if !selectedEquipments.contains(item) {
            selectedEquipments.append(item)
        } else {
            if let index = selectedEquipments.firstIndex(of: item) {
              selectedEquipments.remove(at: index)
            }
        }
    }
    
    func applyFilters() {
        workoutManager.applyFilters(bodyParts: selectedBodyParts, equipments: selectedEquipments)
    }
}
