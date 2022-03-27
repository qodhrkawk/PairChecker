//
//  PeopleListViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import Foundation

class PeopleListViewModel {
    
    @Published var people: [Person] = []
    
    
    init() {
        people = PeopleStoreManager.shared.getStoredPeople()
    }
    
    func deletePerson(index: Int) {
        people.remove(at: index)
        PeopleStoreManager.shared.updatePeople(people: people)
    }
    
}
