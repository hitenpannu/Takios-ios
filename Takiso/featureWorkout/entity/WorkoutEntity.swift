//
//  WorkoutEntity.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

struct BodyPartEntity : Decodable {
    let id: String
    let name: String
}

struct EquipmentEntity : Decodable {
    let id: String
    let name: String
}

struct ExerciseEntity : Decodable {
    let id: String
    let name: String
    let bodyParts: [BodyPartEntity]
    let equipments: [EquipmentEntity]
}
