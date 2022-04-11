//
//  BloodTypeChecker.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/07.
//

import Foundation

enum BloodType: Int, Codable, CaseIterable {
    case A = 0, B, AB, O
    
    var koreanName: String {
        switch self {
        case .A: return "A형"
        case .B: return "B형"
        case .AB: return "AB형"
        case .O: return "O형"
        }
    }
}

enum Gender: Int {
    case male = 0, female
}

struct ComputableBlood {
    var bloodType: BloodType
    var gender: Gender
}

public class BloodTypeChecker {
    
    var scoreArray: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    
    init() {
        let A = [70, 25, 90, 50]
        let B = [20, 65, 80, 85]
        let O = [90, 75, 40, 35]
        let AB = [65, 80, 30, 90]
        scoreArray = [A, B, O, AB]
    }
    
    func calculate(value1: ComputableBlood, value2: ComputableBlood) -> Int {
        guard value1.gender == value2.gender else {
            return scoreArray[value1.bloodType.rawValue][value2.bloodType.rawValue]
        }
         
        let sum = (scoreArray[value1.bloodType.rawValue][value2.bloodType.rawValue] +
                   scoreArray[value2.bloodType.rawValue][value1.bloodType.rawValue])
        return sum / 2
    }
}
