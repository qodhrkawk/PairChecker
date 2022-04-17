//
//  PairCheckViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/04.
//

import Foundation
import Combine
import UIKit

enum PairCheckComponent: String, CaseIterable, Equatable {
    case name, sign, mbti, bloodType
    
    var title: String {
        switch self {
        case .name: return "이름점"
        case .sign: return "별자리"
        case .mbti: return "MBTI"
        case .bloodType: return "혈액형"
        }
    }
    
    var subTitle: String {
        switch self {
        case .name: return "한국 전통의 과학점"
        case .sign: return "서양 전통의 과학점"
        case .mbti: return "요즘 우리의 과학점"
        case .bloodType: return "일본 전통의 과학점"
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .name: return .animalSkyblue
        case .sign: return .animalYellow
        case .mbti: return .animalOrange
        case .bloodType: return .animalPink
        }
    }
    
    var highlightImage: UIImage? {
        switch self {
        case .name: return UIImage(named: "imgSelectedLineBlue")
        case .sign: return UIImage(named: "imgSelectedLineYellow")
        case .mbti: return UIImage(named: "imgSelectedLineOrange")
        case .bloodType: return UIImage(named: "imgSelectedLinePink")
        }
    }
}

struct PairCheckComponentModel: Hashable {
    let component: PairCheckComponent
    var available: Bool = true
    var selected: Bool = false
}

class PairCheckViewModel {
    @Published var selectedPeople: [Person] = []
    @Published var people: [Person] = UserManager.shared.getStoredPeople()
    @Published var mainAnimal: Animal?
    
    @Published var pairCheckComponentModelsPublisher: [PairCheckComponentModel] = []
    @Published var pairCheckComponentSelected: Bool = false
    @Published var selectedIconImage: UIImage? = UIImage(named: "icAllselectInactive")
    
    private var pairCheckComponentModels: [PairCheckComponentModel] = []
    
    init() {
        prepareComponents()
    }
    
    func addPerson(person: Person) {
        selectedPeople.append(person)
        mainAnimal = person.animal
        people.removeAll(where: { $0 == person })
    }
    
    func bindPairComponentViewController() {
        adaptComponentModelsForSelectedPeople()
        publishPairCheckComponentModel()
    }
    
    func publishPairCheckComponentModel() {
        pairCheckComponentModelsPublisher = pairCheckComponentModels
    }
    
    func selectAllComponents() {
        for index in 0..<pairCheckComponentModels.count {
            if pairCheckComponentModels[index].available {
                pairCheckComponentModels[index].selected = true
            }
        }
        checkIfPairCheckIsSelected()
    }
    
    private func prepareComponents() {
        guard people.count == 2 else { return }
        PairCheckComponent.allCases.forEach { component in
            switch component {
            case .name:
                pairCheckComponentModels.append(PairCheckComponentModel(component: component))
            case .sign:
                pairCheckComponentModels.append(PairCheckComponentModel(component: component))
            case .mbti:
                if people[0].mbti != nil && people[1].mbti != nil {
                    pairCheckComponentModels.append(PairCheckComponentModel(component: component))
                }
                else {
                    pairCheckComponentModels.append(PairCheckComponentModel(component: component, available: false))
                }
            case .bloodType:
                if people[0].bloodType != nil && people[1].bloodType != nil {
                    pairCheckComponentModels.append(PairCheckComponentModel(component: component))
                }
                else {
                    pairCheckComponentModels.append(PairCheckComponentModel(component: component, available: false))
                }
            }
        }
        
    }
    
    private func adaptComponentModelsForSelectedPeople() {
        guard selectedPeople.count == 2,
              pairCheckComponentModels.count == 4
        else { return }
        
        for index in 1...3 {
            switch index {
            case 1:
                if selectedPeople[0].sign == nil || selectedPeople[1].sign == nil {
                    self.pairCheckComponentModels[index].available = false
                }
            case 2:
                if selectedPeople[0].mbti == nil || selectedPeople[1].mbti == nil {
                    self.pairCheckComponentModels[index].available = false
                }
            default:
                if selectedPeople[0].bloodType == nil || selectedPeople[1].bloodType == nil {
                    self.pairCheckComponentModels[index].available = false
                }
            }
        }
    }
    
    private func checkIfAllComponentsSelected() {
        for pairCheckComponentModel in pairCheckComponentModels {
            guard pairCheckComponentModel.available else { continue }
            if !pairCheckComponentModel.selected {
                selectedIconImage = UIImage(named: "icAllselectInactive")
                return
            }
        }
        selectedIconImage = UIImage(named: "icAllselectActive")
    }
    
    private func checkIfPairCheckIsSelected() {
        checkIfAllComponentsSelected()
        for pairCheckComponentModel in pairCheckComponentModels {
            if pairCheckComponentModel.selected {
                pairCheckComponentSelected = true
                return
            }
        }
        pairCheckComponentSelected = false
        return
    }
    
}

extension PairCheckViewModel: PairComponentTableViewCellDelegate {
    func componentIsTapped(component: PairCheckComponent) {
        for index in 0..<pairCheckComponentModels.count {
            if pairCheckComponentModels[index].component == component {
                pairCheckComponentModels[index].selected = !pairCheckComponentModels[index].selected
            }
        }

        checkIfPairCheckIsSelected()
    }
}
