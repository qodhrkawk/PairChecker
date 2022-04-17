//
//  Animal.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/25.
//

import Foundation
import UIKit

enum Animal: String, CaseIterable, Codable {
    case fox, cat, pig, bear, dog, duck, tiger, rabbit, frog, hamster
    
    var themeColor: ThemeColor {
        switch self {
        case .fox, .tiger: return .orange
        case .rabbit, .pig: return .pink
        case .dog, .frog: return .green
        case .duck, .hamster: return .yellow
        case .bear, .cat: return .skyblue
        }
    }
    
    var imageName: String {
        "img" + self.rawValue
    }
    
    var stickerImage: UIImage? {
        UIImage(named: "imgSticker" + self.rawValue)
    }
}

