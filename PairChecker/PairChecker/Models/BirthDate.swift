//
//  BirthDate.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/10.
//

import Foundation

struct BirthDate: Codable, Hashable {
    let month: Int
    let day: Int
    
    var stringFromBrithDate: String {
        var monthString = String(month)
        var dayString = String(day)
        if month / 10 == 0 {
            monthString = "0" + monthString
        }
        if day / 10 == 0 {
            dayString = "0" + dayString
        }
            
        return monthString + "." + dayString
    }
    
    static var monthToDate: [Int: Int] = [
        1:31, 2:29, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31
    ]
    
    static func canMakeValidBirthDate(month: Int, day: Int) -> Bool{
        guard month > 0, month < 13,
              let maximumDay = Self.monthToDate[month]
        else { return false }
        if maximumDay < day || day <= 0 {
            return false
        }
        return true
    }
    
}
