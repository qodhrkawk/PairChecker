//
//  BloodTypeChecker.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/07.
//

import Foundation

enum BloodType: Int, Codable, CaseIterable {
    case A = 0, B, O, AB
    
    var koreanName: String {
        switch self {
        case .A: return "A형"
        case .B: return "B형"
        case .O: return "O형"
        case .AB: return "AB형"
        }
    }
}

enum Gender: Int {
    case male = 0, female
}


public class BloodTypeChecker {
    
    static let shared = BloodTypeChecker()
    var scoreArray: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    
    init() {
        let A = [70, 25, 90, 50]
        let B = [20, 65, 80, 85]
        let O = [90, 75, 40, 35]
        let AB = [65, 80, 30, 90]
        scoreArray = [A, B, O, AB]
    }
    
    func calculate(value1: BloodType, value2: BloodType) -> Int {
        let sum = (scoreArray[value1.rawValue][value2.rawValue] +
                   scoreArray[value2.rawValue][value1.rawValue])
        return sum / 2
    }
}
