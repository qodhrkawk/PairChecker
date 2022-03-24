//
//  NameChecker.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/02/11.
//

import Foundation

public class NameChecker {
    
    public static let shared = NameChecker()

    let chosung = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    let jungsung = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]
    let jongsung = [" ", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    
    let strokeDict: [Int: [String]] = [1: ["ㄱ", "ㄴ", "ㅇ", "ㅡ", "ㅣ"],
                                       2: ["ㄷ", "ㅅ", "ㅈ", "ㅋ", "ㄲ", "ㅏ", "ㅓ", "ㅗ", "ㅜ", "ㅢ"],
                                       3: ["ㄹ", "ㅁ", "ㅊ", "ㅌ", "ㅎ", "ㅐ", "ㅔ", "ㅚ", "ㅟ", "ㅕ", "ㅛ", "ㅠ", "ㅟ"],
                                       4: ["ㅂ", "ㅍ", "ㄸ", "ㅆ", "ㅉ", "ㅘ", "ㅝ", "ㅒ", "ㅖ"],
                                       5: ["ㅙ", "ㅞ"]
    ]
    
    var reverseStrokeDict: [String: Int] = [:]
    
    init() {
        setReverseStrokeDict()
    }
    
    func checkValidHangeul(input: String) -> Bool {
        for scalar in input.unicodeScalars {
            guard scalar.value >= 44032 && scalar.value <= 55203 else { return false }
        }
        return true
    }
    
    func calculate(value1: String, value2: String) -> Int {
        let sliced = [sliceHangeul(hangeul: value1), sliceHangeul(hangeul: value2)]
        return calculateNamePair(name1: sliced[0], name2: sliced[1])
    }
    
    func sliceHangeul(hangeul: String) -> [[String]] {
        var answer:[[String]] = []
        for scalar in hangeul.unicodeScalars {
            guard scalar.value >= 44032 && scalar.value <= 55203 else { continue }
            
            let cho = Int((Int(scalar.value) - 44032) / 588)
            let jung = Int(((Int(scalar.value) - 44032) - (588 * cho)) / 28)
            let jong = (Int(scalar.value) - 44032) - (588 * cho) - 28 * jung
            
            answer.append([chosung[cho], jungsung[jung], jongsung[jong]])
        }
        
        return answer
    }
    
    func setReverseStrokeDict() {
        for (key, value) in strokeDict {
            for elem in value {
                reverseStrokeDict[elem] = key
            }
        }
    }

    func calculateNamePair(name1: [[String]], name2: [[String]]) -> Int {
    
        var (name1Value, name2Value) = ([Int](repeating: 0, count: name1.count), [Int](repeating: 0, count: name2.count))
        for iter in 0..<name1.count {
            for sung in name1[iter] {
                name1Value[iter] += reverseStrokeDict[sung] ?? 0
            }
        }
        
        for iter in 0..<name2.count {
            for sung in name2[iter] {
                name2Value[iter] += reverseStrokeDict[sung] ?? 0
            }
        }

        return calculateNameJum(name1: name1Value, name2: name2Value)
    }

    func calculateNameJum(name1: [Int], name2: [Int]) -> Int {
        let nameString1 = name1.reduce("",{String($0) + String($1)})
        let nameString2 = name2.reduce("",{String($0) + String($1)})
        
        var calculateString = ""
        
        if name1.count < name2.count {
            for iter in 0..<name2.count {
                calculateString += String(nameString2[nameString2.index(nameString2.startIndex, offsetBy: iter)])
                if name1.count > iter {
                    calculateString += String(nameString1[nameString1.index(nameString1.startIndex, offsetBy: iter)])
                }
            }
        }
        else {
            for iter in 0..<name1.count {
                calculateString += String(nameString1[nameString1.index(nameString1.startIndex, offsetBy: iter)])
                if name2.count > iter {
                    calculateString += String(nameString2[nameString2.index(nameString2.startIndex, offsetBy: iter)])
                }
            }
        }
        
        while calculateString.count > 2 {
            var newCalculateString = ""
                    
            for index in 0..<calculateString.count - 1 {
                guard
                    let num1 = Int(calculateString[index]),
                    let num2 = Int(calculateString[index + 1])
                else { break }
                let sum = num1 + num2
                if sum == 10 && index == 0 {
                    newCalculateString += "10"
                }
                else {
                    newCalculateString += String((num1 + num2) % 10)
                }
            }
            if newCalculateString == "100" {
                return 100
            }
            
            calculateString = newCalculateString
        }
        guard let result = Int(calculateString) else { return 0 }
        
        return result
    }
    
}
