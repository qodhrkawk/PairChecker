//
//  MainText.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/24.
//

import Foundation

enum MainText: Int, CaseIterable {
    case chaldduck = 0, chaldduckQuestion, fun, possibility, heart
    
    var text: String {
        switch self {
        case .chaldduck:
            return "유사과학도 인정한\n찰떡궁합을 찾아서...🚀🙄"
        case .chaldduckQuestion:
            return "우린 과연 얼마나\n찰떡궁합일까?😍❤️"
        case .fun:
            return "유사과학인거 나도 알지만\n재밌는걸 어떡해!😆🔥"
        case .possibility:
            return "유사과학 아닙니다.\n확률과 통계입니다!😛✌🏻"
        case .heart:
            return "궁합 결과보다 중요한건\n너랑 나의 마음이야😉💕"
        }
    }
    
}
