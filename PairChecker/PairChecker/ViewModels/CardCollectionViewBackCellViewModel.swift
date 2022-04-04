//
//  CardCollectionViewBackCellViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/26.
//

import Foundation
import Combine

class CardCollectionViewBackCellViewModel {
    @Published var person: Person
    
    init(person: Person) {
        self.person = person
    }
    
}
