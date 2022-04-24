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
    
    static var dummyPersonForSection: Person {
        return Person(animal: .bear, name: "", birthDate: BirthDate(month: 1, day: 1), sign: nil, bloodType: nil, mbti: nil, createdAt: Date())
    }
}
