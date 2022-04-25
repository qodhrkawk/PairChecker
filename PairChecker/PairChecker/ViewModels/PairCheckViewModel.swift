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
    
    @Published var graphElements: [ResultGraphElement] = []
    @Published var secondResultText: String = ""
    
    private var pairCheckComponentModels: [PairCheckComponentModel] = []
        
    init() {
        
    }
    
    func reloadPeople() {
        self.people = UserManager.shared.getStoredPeople()
        if selectedPeople.count != 0 {
            people.removeAll(where: { $0 == selectedPeople[0] })
        }
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
    
    func selectAllComponents() -> Bool {
        guard pairCheckComponentModels.filter({ $0.selected == true }).count !=
                pairCheckComponentModels.filter({ $0.available == true }).count
        else {
            for index in 0..<pairCheckComponentModels.count {
                if pairCheckComponentModels[index].available {
                    pairCheckComponentModels[index].selected = false
                }
            }
            checkIfPairCheckIsSelected()
            return false
        }
                
        for index in 0..<pairCheckComponentModels.count {
            if pairCheckComponentModels[index].available {
                pairCheckComponentModels[index].selected = true
            }
        }
        checkIfPairCheckIsSelected()
        return true
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
                if selectedPeople[0].mbti != nil && selectedPeople[1].mbti != nil {
                    pairCheckComponentModels.append(PairCheckComponentModel(component: component))
                }
                else {
                    pairCheckComponentModels.append(PairCheckComponentModel(component: component, available: false))
                }
            case .bloodType:
                if selectedPeople[0].bloodType != nil && selectedPeople[1].bloodType != nil {
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
        publishSecondResultText(scoreArray: self.pairCheckResult)
        publishGraphElements()
    }
    
    private func publishGraphElements() {
        guard pairCheckResult.count == 4 else { return }
        
        let colors: [UIColor] = [.animalSkyblue, .golden, .animalOrange, .animalPink]
            
        var graphElements: [ResultGraphElement] = []
        
        for index in 0...3 {
            graphElements.append(ResultGraphElement(componentName: PairCheckComponent.allCases[index].title, score: pairCheckResult[index], color: colors[index]))
        }
        
        graphElements.sort { return $0.score ?? 0 > $1.score ?? 0 }
        
        self.graphElements = graphElements
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
    
    private func publishSecondResultText(scoreArray: [Int?]) {
        let unwrappedScoreArray = scoreArray.compactMap({ $0 })
        guard unwrappedScoreArray.count > 0
        else {
            secondResultText =  ""
            return
        }
                
        if unwrappedScoreArray.count == 1 {
            guard let index = scoreArray.firstIndex(of: unwrappedScoreArray[0]) else { return }
            secondResultText = """
            \(PairCheckComponent.allCases[index].title) 궁합이 가장 재미난건 나도 인정!👍🏻
            근데 다른 궁합도 궁금하지 않니?ㅎㅎ
            다양한 친구들의 프로필도 모으고, 궁합점을 시도해봐!
            혼자 하는것보다 여럿이 해야 재밌다구~🙂
            아, 높은 점수와 최고점은 인증 필수인거 알지?!~
            """
            return
        }
        
        let maximumScore = unwrappedScoreArray.max()
        
        for (index, score) in scoreArray.enumerated() {
            if score == maximumScore {
                switch index {
                case 0:
                    secondResultText = """
                    둘은 이름점에서 가장 높은 점수를 받았네.
                    이름점은 상대적으로 높은 점수를 얻기 어려운데...😯
                    원래 평생 불릴 이름이 가장 중요한거 알지?😆
                    이 관계를 오래 유지하고 싶다면 개명은 신중히
                    생각해보는 걸 추천해!😉
                    """
                case 1:
                    secondResultText = """
                    둘은 별자리에서 가장 높은 점수를 받았네.
                    별자리는 예로부터 서양에서 사람의 성격과 기질을 따온걸로 알려졌대. 둘의 성격은 잘 맞는 편인가봐! 😆
                    아, 별자리는 태어난 날을 기준으로 하기 때문에 이 궁합은 영원할거야. 로맨틱하지 않아?😍
                    """
                case 2:
                    secondResultText = """
                    둘은 MBTI에서 가장 높은 점수를 받았네.
                    다른것보다 MBTI는 과학에 좀 더 가까운거 알지?ㅎ
                    보통 MBTI는 서로가 온전히 닮았다기보단 상호보완적일수록 높은 점수를 얻어. 고로 둘은 서로에게 꼭 맞는 퍼즐같은 존재! 앞으로도 오래오래 행복하길☺️
                    """
                case 3:
                    secondResultText = """
                    둘은 혈액형에서 가장 높은 점수를 받았네.
                    10년전만 해도 궁합계의 탑이었던 혈액형!!!😯
                    인기있었던데는 그만한 이유가 있지. 피가 인증한 사이는 원래 다른것보다 더욱 진실되고 진하다구😎❤️
                    둘은 앞으로도 찐-하게 함께할 수 있을거야!
                    """
                default: break
                }
            }
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
