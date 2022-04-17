//
//  AddPersonViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/09.
//

import Combine


class AddPersonViewModel {
        
    private var name: String?
    private var birthDate: BirthDate?
    private var mbti: MBTI?
    private var animal: Animal?

    @Published var person: Person? {
        didSet {
            personDidSet()
        }
    }
    @Published var bloodType: BloodType?
    @Published var sign: Sign?
    @Published var mbtiButtonBooleanInfos: [Bool] = []
    @Published var personCanbeMade: Bool = false
    
    let animalButtonArray: [Animal] = [.rabbit, .fox, .frog, .pig, .tiger, .duck, .dog, .bear, .cat, .hamster]
    
    init() {
        setupInitialValues()
    }
    
    func setupInitialValues() {
        bloodType = .A
        mbtiButtonBooleanInfos = [true, true, true, true]
        makeMBTIfromBooleanInfos()
    }
    
    func personDidSet() {
        guard let person = person else { return }
        self.name = person.name
        self.birthDate = person.birthDate
        self.mbti = person.mbti
        self.animal = person.animal
        self.bloodType = person.bloodType
        self.sign = person.sign
        
        if let mbti = person.mbti {
            self.mbtiButtonBooleanInfos = [
                mbti.stringName[0] == "E",
                mbti.stringName[1] == "S",
                mbti.stringName[2] == "F",
                mbti.stringName[3] == "P",
            ]
        }
        else {
            self.mbtiButtonBooleanInfos = []
        }
        
        checkIfPersonCanbeMade()
    }
    
    func updateName(name: String) {
        guard name != ""
        else {
            self.name = nil
            return
        }
        self.name = name
        checkIfPersonCanbeMade()
    }
    
    func updateBirthDate(month: String, day: String) {
        guard let monthInteger = Int(month),
              let dayInteger = Int(day),
              BirthDate.canMakeValidBirthDate(month: monthInteger, day: dayInteger)
        else {
            self.sign = nil
            self.birthDate = nil
            return
        }
        
        self.birthDate = BirthDate(month: monthInteger, day: dayInteger)
        self.sign = SignChecker.shared.getSignFromDate(month: monthInteger, day: dayInteger)
        checkIfPersonCanbeMade()
    }
    
    func updateBloodTypeInfo(buttonNum: Int) {
        guard buttonNum < 4
        else {
            self.bloodType = nil
            return
        }
        for bloodType in BloodType.allCases {
            if bloodType.rawValue == buttonNum {
                self.bloodType = bloodType
            }
        }
    }
    
    func updateMBTIBooleanInfos(buttonNum: Int) {
        guard buttonNum < 8 else { return }
        if mbtiButtonBooleanInfos.count == 0 {
            mbtiButtonBooleanInfos = [true, true, true, true]
        }
        mbtiButtonBooleanInfos[buttonNum / 2] = buttonNum % 2 == 0
        makeMBTIfromBooleanInfos()
    }
    
    func updateMBTItoUnknwon() {
        mbtiButtonBooleanInfos = []
        makeMBTIfromBooleanInfos()
    }
    
    func updateAnimalInfo(buttonNum: Int) {
        self.animal = animalButtonArray[buttonNum]
        checkIfPersonCanbeMade()
    }
    
    func registerPerson() -> Person? {
        guard let animal = animal,
              let name = name,
              let birthDate = birthDate
        else { return nil }

        let person = Person(animal: animal, name: name, birthDate: birthDate, sign: sign, bloodType: bloodType, mbti: mbti)
        
        guard let originPerson = self.person else {
            UserManager.shared.storePerson(person: person)
            return nil
        }
        
        UserManager.shared.updateSinglePerson(from: originPerson, to: person)
        return person
    }
    
    private func checkIfPersonCanbeMade() {
        guard name != nil, birthDate != nil, sign != nil, animal != nil
        else {
            personCanbeMade = false
            return
        }
        personCanbeMade = true
    }
    
    private func makeMBTIfromBooleanInfos() {
        guard mbtiButtonBooleanInfos.count == 4 else {
            mbti = nil
            return
        }
        var mbtiString = ""
        let trueStrings = ["E","S","F","P"]
        let falseStrings = ["I","N","T","J"]
        
        for index in 0...3 {
            if mbtiButtonBooleanInfos[index] {
                mbtiString += trueStrings[index]
            }
            else {
                mbtiString += falseStrings[index]
            }
        }
        
        for mbti in MBTI.allCases {
            if mbti.stringName == mbtiString {
                self.mbti = mbti
            }
        }
        checkIfPersonCanbeMade()
    }
    
    
}
