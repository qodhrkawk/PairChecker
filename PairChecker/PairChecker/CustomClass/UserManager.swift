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
//        if getStoredPeople().count == 0 {
//            Animal.allCases.forEach { animal in
//                storePerson(person: Person(animal: animal, name: "이예슬", birthDate: BirthDate(month: 5, day: 1), sign: .taurus, bloodType: .A, mbti: .ENFP))
//            }
//        }
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
    
}
