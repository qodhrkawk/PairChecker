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
    
    @Published var pairCheckResult: [Int?] = []
    @Published var averageScore: Int = 0
    @Published var resultText: String = ""
    
    private var pairCheckComponentModels: [PairCheckComponentModel] = []
    
    init() {
        
    }
    
    func addMainPerson(person: Person) {
        selectedPeople.append(person)
        mainAnimal = person.animal
        people.removeAll(where: { $0 == person })
    }
    
    func addSubPerson(person: Person) {
        selectedPeople.append(person)
    }
    
    func bindPairComponentViewController() {
        prepareComponents()
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
    
    func moveToResultView() {
        calculatePair()
    }
    
    private func prepareComponents() {
        guard selectedPeople.count == 2 else { return }
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
    
    private func calculatePair() {
        var checkList: [CheckList] = []
        for (index, model) in pairCheckComponentModels.enumerated() {
            guard model.selected else { continue }
            checkList.append(CheckList.allCases[index])
        }
        pairCheckResult = PairChecker.shared.calculatePair(mainPerson: selectedPeople[0], subPerson: selectedPeople[1], checkList: checkList)
        averageScore = pairCheckResult.compactMap { $0 }.reduce(0) { $0 + $1 } / pairCheckResult.compactMap { $0 }.count
        publishResultText(averageScore: averageScore)
    }
    
    
    private func publishResultText(averageScore: Int) {
        switch averageScore {
        case 20...29:
            resultText = "궁합점은 재미로 보는거긴 한데...\n둘이 사이 괜찮은거지?"
        case 30...39:
            resultText = "잦은 다툼없이 평화로운 사이!\n꽤나 괜찮은 찰떡궁합이야!"
        case 40...49:
            resultText = "정으로 만나고 있는것 같은데?\n아, 정이 나쁜건 아니잖아!"
        case 50...59:
            resultText = "잦은 다툼없이 평화로운 사이!\n꽤나 괜찮은 찰떡궁합이야!"
        case 60...69:
            resultText = "함께 하면 즐거운 사이!\n꽤 멋진 찰떡궁합이야!"
        case 70...79:
            resultText = "나도 너네 사이에 끼고 싶은걸?\n부러워할만한 찰떡궁합이야!"
        case 80...89:
            resultText = "유사과학까지 인정해버린 둘!\n이정도면 베스트 찰떡궁합!"
        case 90...100:
            resultText = "혹시 둘이 전생에 부부였어...?\n최고로 완벽한 찰떡궁합이야!"
            
        default:
            resultText = "궁...궁합은 재미로 보는거야!\n유사과학 아웃! 밴! 차단!"
        }
        
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
