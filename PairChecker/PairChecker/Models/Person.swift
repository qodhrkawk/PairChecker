//
//  Person.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/25.
//

import Foundation

struct Person: Hashable, Codable {
    let animal: Animal
    let name: String
    let birthDate: String?
    let sign: Sign?
    let bloodType: BloodType?
    let mbti: MBTI?
    
    var front: Bool = true
}
