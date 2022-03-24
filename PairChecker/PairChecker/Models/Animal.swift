//
//  Animal.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/25.
//

import Foundation
import UIKit

enum Animal: String, CaseIterable {
    case fox, unicorn, panda, cat, pig, bear, chick, dog, fish, tiger, rat, frog
    
    var themeColor: ThemeColor {
        switch self {
        case .fox, .tiger: return .orange
        case .unicorn, .pig: return .pink
        case .panda, .frog: return .green
        case .cat, .chick: return .yellow
        case .bear, .rat: return .purple
        case .dog, .fish: return .skyblue
        }
    }
    
    var imageName: String {
        self.rawValue
    }
}

