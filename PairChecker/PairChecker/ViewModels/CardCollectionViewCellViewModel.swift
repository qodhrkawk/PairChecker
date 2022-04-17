//
//  CardCollectionViewCellViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/25.
//

import Foundation
import Combine

class CardCollectionViewCellViewModel {
    @Published var person: Person
    var front: Bool = true
    
    init(person: Person) {
        self.person = person
    }
    
    func check() {
        
    }
    
}
