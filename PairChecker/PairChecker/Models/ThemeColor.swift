//
//  ThemeColor.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/25.
//

import Foundation
import UIKit

enum ThemeColor: String, CaseIterable {
    case green, pink, yellow, skyblue, orange
    
    var highlightImageString: String {
        self.rawValue + "Highlight"
    }
    
    var highlightCircleString: String {
        self.rawValue + "Circle"
    }
    
    var uicolor: UIColor {
        switch self {
        case .green: return .animalGreen
        case .pink: return .animalPink
        case .yellow: return .animalYellow
        case .skyblue: return .animalSkyblue
        case .orange: return .animalOrange
        }
    }
    
}
