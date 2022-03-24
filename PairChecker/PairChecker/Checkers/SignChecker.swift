//
//  SignChecker.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/05.
//

import Foundation

public enum Sign: Int, CaseIterable {
    case aries = 0, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces
    
    var koreanName: String {
        switch self {
        case .aries: return "양자리"
        case .taurus: return "황소자리"
        case .gemini: return "쌍둥이자리"
        case .cancer: return "게자리"
        case .leo:  return "사자자리"
        case .virgo: return "처녀자리"
        case .libra: return "천칭자리"
        case .scorpio: return "전갈자리"
        case .sagittarius: return "궁수자리"
        case .capricorn: return "염소자리"
        case .aquarius: return "물병자리"
        case .pisces: return "물고기자리"
        }
    }
}

struct ComputableSign {
    var sign: Sign
    var gender: Gender
}

public class SignChecker {
    
    public let shared = SignChecker()
    var scoreArray: [[Int]] = Array(repeating: Array(repeating: 0, count: 12), count: 12)
    
    init() {
        scoreArray = [
            [90, 40, 70, 80, 90, 50, 70, 30, 100, 80, 60, 40],
            [80, 90, 30, 60, 50, 90, 40, 40, 30, 100, 30, 70],
            [60, 30, 90, 30, 60, 40, 100, 50, 70, 80, 100, 30],
            [40, 60, 80, 90, 40, 60, 50, 100, 30, 70, 30, 100],
            [90, 40, 70, 30, 100, 50, 70, 50, 90, 80, 40, 30],
            [60, 100, 80, 70, 50, 90, 50, 60, 40, 100, 30, 70],
            [60, 50, 100, 40, 60, 80, 100, 40, 70, 80, 90, 50],
            [40, 70, 50, 90, 80, 70, 80, 90, 30, 70, 50, 100],
            [90, 80, 70, 30, 100, 50, 70, 30, 90, 80, 60, 40],
            [50, 100, 40, 70, 60, 100, 40, 60, 80, 90, 50, 70],
            [60, 80, 100, 30, 60, 50, 90, 80, 70, 40, 100, 30],
            [80, 60, 80, 100, 60, 40, 50, 90, 50, 60, 30, 90]
        ]
    }
    
    func getSignFromDate(month: Int, day: Int) -> Sign {
        switch month * 100 + day {
        case 321...419: return .aries
        case 420...520: return .taurus
        case 521...621: return .gemini
        case 622...722: return .cancer
        case 723...822: return .leo
        case 823...923: return .virgo
        case 924...1022: return .libra
        case 1023...1122: return .scorpio
        case 1123...1224: return .sagittarius
        case 120...218: return .aquarius
        case 219...320: return .pisces
        default: return .capricorn
        }
    }
    
    func calculate(value1: ComputableSign, value2: ComputableSign) -> Int {
        guard value1.gender == value2.gender else {
            return scoreArray[value1.sign.rawValue][value2.sign.rawValue]
        }
        
        let sum = (scoreArray[value1.sign.rawValue][value2.sign.rawValue] +
                   scoreArray[value2.sign.rawValue][value1.sign.rawValue])
        return sum / 2
    }
    
}
