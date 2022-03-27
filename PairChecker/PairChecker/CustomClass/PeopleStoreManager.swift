//
//  PeopleStoreManager.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import Foundation


class PeopleStoreManager {
    
    static let shared = PeopleStoreManager()
    
    @UserDefaultWrapper<[Person]>(key: UserDefaultsKey.people) private var people
    
    func getStoredPeople() -> [Person] {
        return people ?? []
    }
    
    func storePerson(person: Person) {
        if people == nil { people = [person] }
        else { self.people?.append(person) }
    }
    
    func updatePeople(people: [Person]) {
        self.people = people
    }
    
}
