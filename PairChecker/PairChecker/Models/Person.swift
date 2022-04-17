//
//  Person.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/25.
//

import Foundation

struct Person: Hashable, Codable, Equatable {
    let animal: Animal
    let name: String
    let birthDate: BirthDate
    let sign: Sign?
    let bloodType: BloodType?
    let mbti: MBTI?
    let createdAt: Date
}
