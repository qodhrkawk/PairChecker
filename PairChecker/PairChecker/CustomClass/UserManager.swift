//
//  UserManager.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import Foundation


class UserManager {
    
    static let shared = UserManager()
    
    @UserDefaultWrapper<[Person]>(key: UserDefaultsKey.people) private var people
    @UserDefaultWrapper<Bool>(key: UserDefaultsKey.shouldShowOnboarding) var shouldShowOnboarding
    
    init() {

    }
    
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
    
    func updateSinglePerson(from: Person, to: Person) {
        guard let people = people else { return }
        var newPeople = people
        
        if let index = newPeople.firstIndex(of: from) {
            newPeople[index] = to
        }
        print(from)
        print(to)
        print(newPeople)
        updatePeople(people: newPeople)
    }
    
    func deletePerson(person: Person) {
        guard let people = people else { return }
        var newPeople = people
        newPeople.removeAll(where: { $0 == person })
        updatePeople(people: newPeople)
    }
    
}
