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
    
//    var front: Bool = true
}

//extension Person: Equatable {
//    static func ==(lhs: Person, rhs: Person) -> Bool{
//        return lhs.animal == rhs.animal &&
//        lhs.name == rhs.name &&
//        lhs.birthDate == rhs.birthDate &&
//        lhs.sign == rhs.sign &&
//        lhs.bloodType == rhs.bloodType &&
//        lhs.mbti == rhs.mbti
//    }
//}
