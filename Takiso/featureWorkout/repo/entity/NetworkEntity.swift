//
//  NetworkEntity.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

struct NetworkBodyPartEntity: Decodable {
    let _id: String
    let name: String
}

struct NetworkEquipmentEntity: Decodable {
    let _id: String
    let name: String
}

struct NetworkExerciseEntity : Decodable {
    let _id: String
    let name: String
    let bodyParts : [NetworkBodyPartEntity]
    let equipments : [NetworkEquipmentEntity]
}

struct ExerciseNetworkResponse : NetworkResponse {
    typealias dataType = [NetworkExerciseEntity]
    var status: Status
    var data: [NetworkExerciseEntity]?
}
