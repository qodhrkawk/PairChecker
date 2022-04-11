//
//  MBTIChecker.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/07.
//

import Foundation

enum MBTI: Int, CaseIterable, Codable {
    case ISTJ = 0, ISFJ, INFJ, INTJ, ISTP, ISFP, INFP, INTP, ESTP, ESFP, ENFP, ENTP, ESTJ, ESFJ, ENFJ, ENTJ
    
    var stringName: String {
        switch self {
        case .ISTJ: return "ISTJ"
        case .ISFJ: return "ISFJ"
        case .INFJ: return "INFJ"
        case .INTJ: return "INTJ"
        case .ISTP: return "ISTP"
        case .ISFP: return "ISFP"
        case .INFP: return "INFP"
        case .INTP: return "INTP"
        case .ESTP: return "ESTP"
        case .ESFP: return "ESFP"
        case .ENFP: return "ENFP"
        case .ENTP: return "ENTP"
        case .ESTJ: return "ESTJ"
        case .ESFJ: return "ESFJ"
        case .ENFJ: return "ENFJ"
        case .ENTJ: return "ENTJ"
        }
        
    }
    
}

public class MBTIChecker {
    
    static let shared = MBTIChecker()
    var scoreArray: [[Int]] = Array(repeating: Array(repeating: 0, count: 16), count: 16)
    
    init() {
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ISTJ.rawValue] = 55
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ISFJ.rawValue] = 40
        scoreArray[MBTI.ISTJ.rawValue][MBTI.INFJ.rawValue] = 15
        scoreArray[MBTI.ISTJ.rawValue][MBTI.INTJ.rawValue] = 50
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ISTP.rawValue] = 35
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ISFP.rawValue] = 85
        scoreArray[MBTI.ISTJ.rawValue][MBTI.INFP.rawValue] = 75
        scoreArray[MBTI.ISTJ.rawValue][MBTI.INTP.rawValue] = 70
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ESTP.rawValue] = 70
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ESFP.rawValue] = 70
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ENFP.rawValue] = 100
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ENTP.rawValue] = 95
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ESTJ.rawValue] = 70
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ESFJ.rawValue] = 70
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ENFJ.rawValue] = 10
        scoreArray[MBTI.ISTJ.rawValue][MBTI.ENTJ.rawValue] = 30
        
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ISFJ.rawValue] = 30
        scoreArray[MBTI.ISFJ.rawValue][MBTI.INFJ.rawValue] = 20
        scoreArray[MBTI.ISFJ.rawValue][MBTI.INTJ.rawValue] = 15
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ISTP.rawValue] = 85
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ISFP.rawValue] = 20
        scoreArray[MBTI.ISFJ.rawValue][MBTI.INFP.rawValue] = 45
        scoreArray[MBTI.ISFJ.rawValue][MBTI.INTP.rawValue] = 90
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ESTP.rawValue] = 70
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ESFP.rawValue] = 70
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ENFP.rawValue] = 95
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ENTP.rawValue] = 100
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ESTJ.rawValue] = 50
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ESFJ.rawValue] = 43
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ENFJ.rawValue] = 20
        scoreArray[MBTI.ISFJ.rawValue][MBTI.ENTJ.rawValue] = 10
        
        scoreArray[MBTI.INFJ.rawValue][MBTI.INFJ.rawValue] = 70
        scoreArray[MBTI.INFJ.rawValue][MBTI.INTJ.rawValue] = 72
        scoreArray[MBTI.INFJ.rawValue][MBTI.ISTP.rawValue] = 90
        scoreArray[MBTI.INFJ.rawValue][MBTI.ISFP.rawValue] = 70
        scoreArray[MBTI.INFJ.rawValue][MBTI.INFP.rawValue] = 20
        scoreArray[MBTI.INFJ.rawValue][MBTI.INTP.rawValue] = 87
        scoreArray[MBTI.INFJ.rawValue][MBTI.ESTP.rawValue] = 100
        scoreArray[MBTI.INFJ.rawValue][MBTI.ESFP.rawValue] = 95
        scoreArray[MBTI.INFJ.rawValue][MBTI.ENFP.rawValue] = 75
        scoreArray[MBTI.INFJ.rawValue][MBTI.ENTP.rawValue] = 74
        scoreArray[MBTI.INFJ.rawValue][MBTI.ESTJ.rawValue] = 10
        scoreArray[MBTI.INFJ.rawValue][MBTI.ESFJ.rawValue] = 40
        scoreArray[MBTI.INFJ.rawValue][MBTI.ENFJ.rawValue] = 45
        scoreArray[MBTI.INFJ.rawValue][MBTI.ENTJ.rawValue] = 70
        
        scoreArray[MBTI.INTJ.rawValue][MBTI.INTJ.rawValue] = 55
        scoreArray[MBTI.INTJ.rawValue][MBTI.ISTP.rawValue] = 60
        scoreArray[MBTI.INTJ.rawValue][MBTI.ISFP.rawValue] = 90
        scoreArray[MBTI.INTJ.rawValue][MBTI.INFP.rawValue] = 85
        scoreArray[MBTI.INTJ.rawValue][MBTI.INTP.rawValue] = 40
        scoreArray[MBTI.INTJ.rawValue][MBTI.ESTP.rawValue] = 95
        scoreArray[MBTI.INTJ.rawValue][MBTI.ESFP.rawValue] = 100
        scoreArray[MBTI.INTJ.rawValue][MBTI.ENFP.rawValue] = 70
        scoreArray[MBTI.INTJ.rawValue][MBTI.ENTP.rawValue] = 65
        scoreArray[MBTI.INTJ.rawValue][MBTI.ESTJ.rawValue] = 30
        scoreArray[MBTI.INTJ.rawValue][MBTI.ESFJ.rawValue] = 10
        scoreArray[MBTI.INTJ.rawValue][MBTI.ENFJ.rawValue] = 60
        scoreArray[MBTI.INTJ.rawValue][MBTI.ENTJ.rawValue] = 45
        
        scoreArray[MBTI.ISTP.rawValue][MBTI.ISTP.rawValue] = 50
        scoreArray[MBTI.ISTP.rawValue][MBTI.ISFP.rawValue] = 30
        scoreArray[MBTI.ISTP.rawValue][MBTI.INFP.rawValue] = 15
        scoreArray[MBTI.ISTP.rawValue][MBTI.INTP.rawValue] = 40
        scoreArray[MBTI.ISTP.rawValue][MBTI.ESTP.rawValue] = 70
        scoreArray[MBTI.ISTP.rawValue][MBTI.ESFP.rawValue] = 70
        scoreArray[MBTI.ISTP.rawValue][MBTI.ENFP.rawValue] = 10
        scoreArray[MBTI.ISTP.rawValue][MBTI.ENTP.rawValue] = 35
        scoreArray[MBTI.ISTP.rawValue][MBTI.ESTJ.rawValue] = 75
        scoreArray[MBTI.ISTP.rawValue][MBTI.ESFJ.rawValue] = 95
        scoreArray[MBTI.ISTP.rawValue][MBTI.ENFJ.rawValue] = 100
        scoreArray[MBTI.ISTP.rawValue][MBTI.ENTJ.rawValue] = 77
        
        scoreArray[MBTI.ISFP.rawValue][MBTI.ISFP.rawValue] = 65
        scoreArray[MBTI.ISFP.rawValue][MBTI.INFP.rawValue] = 35
        scoreArray[MBTI.ISFP.rawValue][MBTI.INTP.rawValue] = 15
        scoreArray[MBTI.ISFP.rawValue][MBTI.ESTP.rawValue] = 60
        scoreArray[MBTI.ISFP.rawValue][MBTI.ESFP.rawValue] = 70
        scoreArray[MBTI.ISFP.rawValue][MBTI.ENFP.rawValue] = 55
        scoreArray[MBTI.ISFP.rawValue][MBTI.ENTP.rawValue] = 10
        scoreArray[MBTI.ISFP.rawValue][MBTI.ESTJ.rawValue] = 95
        scoreArray[MBTI.ISFP.rawValue][MBTI.ESFJ.rawValue] = 70
        scoreArray[MBTI.ISFP.rawValue][MBTI.ENFJ.rawValue] = 72
        scoreArray[MBTI.ISFP.rawValue][MBTI.ENTJ.rawValue] = 100
        
        scoreArray[MBTI.INFP.rawValue][MBTI.INFP.rawValue] = 50
        scoreArray[MBTI.INFP.rawValue][MBTI.INTP.rawValue] = 30
        scoreArray[MBTI.INFP.rawValue][MBTI.ESTP.rawValue] = 10
        scoreArray[MBTI.INFP.rawValue][MBTI.ESFP.rawValue] = 40
        scoreArray[MBTI.INFP.rawValue][MBTI.ENFP.rawValue] = 40
        scoreArray[MBTI.INFP.rawValue][MBTI.ENTP.rawValue] = 55
        scoreArray[MBTI.INFP.rawValue][MBTI.ESTJ.rawValue] = 100
        scoreArray[MBTI.INFP.rawValue][MBTI.ESFJ.rawValue] = 73
        scoreArray[MBTI.INFP.rawValue][MBTI.ENFJ.rawValue] = 75
        scoreArray[MBTI.INFP.rawValue][MBTI.ENTJ.rawValue] = 95
        
        scoreArray[MBTI.INTP.rawValue][MBTI.INTP.rawValue] = 43
        scoreArray[MBTI.INTP.rawValue][MBTI.ESTP.rawValue] = 27
        scoreArray[MBTI.INTP.rawValue][MBTI.ESFP.rawValue] = 10
        scoreArray[MBTI.INTP.rawValue][MBTI.ENFP.rawValue] = 50
        scoreArray[MBTI.INTP.rawValue][MBTI.ENTP.rawValue] = 47
        scoreArray[MBTI.INTP.rawValue][MBTI.ESTJ.rawValue] = 85
        scoreArray[MBTI.INTP.rawValue][MBTI.ESFJ.rawValue] = 100
        scoreArray[MBTI.INTP.rawValue][MBTI.ENFJ.rawValue] = 95
        scoreArray[MBTI.INTP.rawValue][MBTI.ENTJ.rawValue] = 70
        
        scoreArray[MBTI.ESTP.rawValue][MBTI.ESTP.rawValue] = 62
        scoreArray[MBTI.ESTP.rawValue][MBTI.ESFP.rawValue] = 30
        scoreArray[MBTI.ESTP.rawValue][MBTI.ENFP.rawValue] = 15
        scoreArray[MBTI.ESTP.rawValue][MBTI.ENTP.rawValue] = 25
        scoreArray[MBTI.ESTP.rawValue][MBTI.ESTJ.rawValue] = 20
        scoreArray[MBTI.ESTP.rawValue][MBTI.ESFJ.rawValue] = 79
        scoreArray[MBTI.ESTP.rawValue][MBTI.ENFJ.rawValue] = 90
        scoreArray[MBTI.ESTP.rawValue][MBTI.ENTJ.rawValue] = 80
        
        scoreArray[MBTI.ESFP.rawValue][MBTI.ESFP.rawValue] = 35
        scoreArray[MBTI.ESFP.rawValue][MBTI.ENFP.rawValue] = 20
        scoreArray[MBTI.ESFP.rawValue][MBTI.ENTP.rawValue] = 15
        scoreArray[MBTI.ESFP.rawValue][MBTI.ESTJ.rawValue] = 75
        scoreArray[MBTI.ESFP.rawValue][MBTI.ESFJ.rawValue] = 25
        scoreArray[MBTI.ESFP.rawValue][MBTI.ENFJ.rawValue] = 85
        scoreArray[MBTI.ESFP.rawValue][MBTI.ENTJ.rawValue] = 85
        
        scoreArray[MBTI.ENFP.rawValue][MBTI.ENFP.rawValue] = 55
        scoreArray[MBTI.ENFP.rawValue][MBTI.ENTP.rawValue] = 35
        scoreArray[MBTI.ENFP.rawValue][MBTI.ESTJ.rawValue] = 75
        scoreArray[MBTI.ENFP.rawValue][MBTI.ESFJ.rawValue] = 80
        scoreArray[MBTI.ENFP.rawValue][MBTI.ENFJ.rawValue] = 38
        scoreArray[MBTI.ENFP.rawValue][MBTI.ENTJ.rawValue] = 70
        
        scoreArray[MBTI.ENTP.rawValue][MBTI.ENTP.rawValue] = 90
        scoreArray[MBTI.ENTP.rawValue][MBTI.ESTJ.rawValue] = 85
        scoreArray[MBTI.ENTP.rawValue][MBTI.ESFJ.rawValue] = 85
        scoreArray[MBTI.ENTP.rawValue][MBTI.ENFJ.rawValue] = 50
        scoreArray[MBTI.ENTP.rawValue][MBTI.ENTJ.rawValue] = 23
        
        scoreArray[MBTI.ESTJ.rawValue][MBTI.ESTJ.rawValue] = 43
        scoreArray[MBTI.ESTJ.rawValue][MBTI.ESFJ.rawValue] = 35
        scoreArray[MBTI.ESTJ.rawValue][MBTI.ENFJ.rawValue] = 15
        scoreArray[MBTI.ESTJ.rawValue][MBTI.ENTJ.rawValue] = 21
        
        scoreArray[MBTI.ESFJ.rawValue][MBTI.ESFJ.rawValue] = 70
        scoreArray[MBTI.ESFJ.rawValue][MBTI.ENFJ.rawValue] = 47
        scoreArray[MBTI.ESFJ.rawValue][MBTI.ENTJ.rawValue] = 15
      
        scoreArray[MBTI.ENFJ.rawValue][MBTI.ENFJ.rawValue] = 80
        scoreArray[MBTI.ENFJ.rawValue][MBTI.ENTJ.rawValue] = 40
        
        scoreArray[MBTI.ENTJ.rawValue][MBTI.ENTJ.rawValue] = 18
        for i in 0...15 {
            for j in 0...15 {
                scoreArray[i][j] = max(scoreArray[i][j], scoreArray[j][i])
            }
        }
    }
    
    func calculate(value1: String, value2: String) -> Int {
        
        return 0
    }
    
    
}
