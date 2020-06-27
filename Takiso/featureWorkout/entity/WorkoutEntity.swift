//
//  WorkoutEntity.swift
//  Takiso
//
//  Created by Pannu, Hitender (Agoda) on 14/6/20.
//  Copyright © 2020 Pannu, Hitender. All rights reserved.
//

import Foundation

struct BodyPart : Decodable, Hashable {
    let id: String
    let name: String
}

struct Equipment : Decodable, Hashable {
    let id: String
    let name: String
}

struct Exercise : Decodable, Hashable {
    let id: String
    let name: String
    let bodyParts: [BodyPart]
    let equipments: [Equipment]
}
