//
//  PeopleSelectViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import Foundation
import Combine

class PeopleSelectViewModel {
    @Published var people = PeopleStoreManager.shared.getStoredPeople()
    @Published var mainAnimal: Animal?
    
    var mainPerson: Person? {
        didSet {
            guard let mainPerson = mainPerson else { return }
            mainAnimal = mainPerson.animal
            people.removeAll(where: { $0 == mainPerson })
        }
    }
    
    
}
