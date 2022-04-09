//
//  AddPersonViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/09.
//

import Combine


class AddPersonViewModel {
    
    private var name: String?
    private var birthDate: String?
    private var mbti: MBTI?
    
    
    
    @Published var bloodType: BloodType?
    @Published var animal: Animal?
    @Published var sign: Sign?
    \
    init() {
        
    }
    
    func updateName(name: String) {
        self.name = name
    }
    
    
}
