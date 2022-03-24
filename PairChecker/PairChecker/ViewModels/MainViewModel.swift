//
//  MainViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/05.
//

import Foundation
import Combine
import UIKit

class MainViewModel {
    
    @Published var mainText: MainText = MainText.chaldduck
    @Published var mainColor: ThemeColor = .green
    
    @Published var people: [Person] = []
    
    private var mainIndexSubscription: AnyCancellable?
    
    init() {
        makeRandomMainText()
        var pp: [Person] = []
        Animal.allCases.forEach {
            pp.append(Person(animal: $0))
        }
        people = pp
        mainColor = pp[0].animal.themeColor
        
    }
    
    func publishColorWithPerson(person: Person) {
        mainColor = person.animal.themeColor
    }
    
    func makeRandomMainText() {
        let randomInt = Int.random(in: 0..<5)
        MainText.allCases.forEach {
            if $0.rawValue == randomInt {
                mainText = $0
            }
        }
    }
    
    
    
}
