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
    
    @Published var currentIndex: Int = 0
    var frontModifedIndex: Int = -1
    
    private var mainIndexSubscription: AnyCancellable?
    
    init() {
        makeRandomMainText()
        reloadPeople()
        
        mainIndexSubscription = $currentIndex
            .sink(receiveValue: { [weak self] index in
                guard let self = self,
                      index >= 0,
                      index < self.people.count
                else { return }
                self.publishColorWithPerson(person: self.people[index])
            })
    }
    
    func reloadPeople() {
        self.people = UserManager.shared.getStoredPeople()
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
    
    func updateCurrentIndex(index: Int) {
        self.currentIndex = index
    }
    
    func updatedFrontInfo() {
        self.frontModifedIndex = -1
    }
    
}
