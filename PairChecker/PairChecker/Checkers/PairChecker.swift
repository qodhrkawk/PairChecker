//
//  PairChecker.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/17.
//

import Foundation

enum CheckList: CaseIterable {
    case name, sign, mbti, bloodType
}

public class PairChecker {
    
    static let shared = PairChecker()

    func calculatePair(mainPerson: Person, subPerson: Person, checkList: [CheckList]) -> [Int?] {
        var resultArray: [Int?] = []
        
        let nameScore = NameChecker.shared.calculate(value1: mainPerson.name, value2: subPerson.name)
        if checkList.contains(.name) {
            resultArray.append(nameScore)
        }
        else {
            resultArray.append(nil)
        }
        
        if let mainPersonSign = mainPerson.sign, let subPersonSign = subPerson.sign, checkList.contains(.sign) {
            let signScore = SignChecker.shared.calculate(value1: mainPersonSign, value2: subPersonSign)
            resultArray.append(signScore)
        }
        else {
            resultArray.append(nil)
        }
        
        if let mainPersonMBTI = mainPerson.mbti, let subPersonMBTI = subPerson.mbti, checkList.contains(.mbti) {
            let mbtiScore = MBTIChecker.shared.calculate(value1: mainPersonMBTI, value2: subPersonMBTI)
            resultArray.append(mbtiScore)
        }
        else {
            resultArray.append(nil)
        }
        
        if let mainPersonBloodType = mainPerson.bloodType, let subPersonBloodType = subPerson.bloodType, checkList.contains(.bloodType) {
            let bloodTypeScore = BloodTypeChecker.shared.calculate(value1: mainPersonBloodType, value2: subPersonBloodType)
            resultArray.append(bloodTypeScore)
        }
        else {
            resultArray.append(nil)
        }
        
        return resultArray
    }


}
