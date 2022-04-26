//
//  AddPersonViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/05.
//

import UIKit
import Combine

class AddPersonViewController: UIViewController {
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var scrollContainView: UIView!
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var subLabels: [UILabel]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var signTextField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    
    @IBOutlet var bloodTypeButtons: [UIButton]!
    @IBOutlet var mbtiButtons: [UIButton]!
    @IBOutlet weak var mbtiUnknownButton: UIButton!
    @IBOutlet var animalButtons: [UIButton]!
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet var lineViews: [UIView]!
    
    @IBOutlet var buttonWidthConstraints: [NSLayoutConstraint]!
    @IBOutlet var stackViewHeightConstraints: [NSLayoutConstraint]!
    
    
    private var bloodTypeSubscription: AnyCancellable?
    private var mbtiSubscription: AnyCancellable?
    private var animalIndexSubscription: AnyCancellable?
    private var signSubscription: AnyCancellable?
    private var finishButtonEnableSubscription: AnyCancellable?
    private var personSubscription: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var addPersonDelegate: AddPersonDelegate?
    let viewModel = AddPersonViewModel()
    
    @Published private var animalButtonIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        bindButtons()
        bindViewModel()
        addScrollContainViewGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.person == nil {
            nameTextField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func prepareUIs() {
        self.view.backgroundColor = .mainBackground
        self.scrollContainView.backgroundColor = .mainBackground
        
        for label in titleLabels {
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .white
        }
        
        for label in subLabels {
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textColor = .white
        }
        
        for bloodTypeButton in bloodTypeButtons {
            bloodTypeButton.backgroundColor = .charcoalGrey
            bloodTypeButton.setTitleColor(.white, for: .normal)
            bloodTypeButton.makeRounded(cornerRadius: 14)
            bloodTypeButton.titleLabel?.font = UIFont(name: "GmarketSansBold", size: 14)
        }
        
        bloodTypeButtons.last?.titleLabel?.font = .systemFont(ofSize: 15)
        
        for mbtiButton in mbtiButtons {
            mbtiButton.backgroundColor = .charcoalGrey
            mbtiButton.setTitleColor(.white, for: .normal)
            mbtiButton.makeRounded(cornerRadius: 14)
            mbtiButton.titleLabel?.font = UIFont(name: "GmarketSansBold", size: 14)
        }
        
        mbtiUnknownButton.backgroundColor = .charcoalGrey
        mbtiUnknownButton.setTitleColor(.white, for: .normal)
        mbtiUnknownButton.makeRounded(cornerRadius: 14)
        
        for animalButton in animalButtons {
            animalButton.backgroundColor = .charcoalGrey
            animalButton.setTitle("", for: .normal)
            animalButton.makeRounded(cornerRadius: 14)
            animalButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }

        finishButton.makeRounded(cornerRadius: 14)
        finishButton.setTitleColor(.black, for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        finishButton.backgroundColor = .animalSkyblue
        
        nameTextField.backgroundColor = .mainBackground
        nameTextField.setBorder(borderColor: .mainBackground, borderWidth: 1.0)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "실명을 정확히 입력해야 정확도가 높아져!",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white20]
        )
        nameTextField.font = .systemFont(ofSize: 16, weight: .bold)
        nameTextField.textColor = .animalSkyblue
        nameTextField.delegate = self
        nameTextField
            .publisher(for: .editingChanged)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.updateName(name: self.nameTextField.text ?? "")
            })
            .store(in: &cancellables)

        
        monthTextField.backgroundColor = .mainBackground
        monthTextField.setBorder(borderColor: .mainBackground, borderWidth: 1.0)
        monthTextField.attributedPlaceholder = NSAttributedString(
            string: "08",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white20]
        )
        monthTextField.font = .systemFont(ofSize: 16, weight: .bold)
        monthTextField.textColor = .animalSkyblue
        monthTextField
            .publisher(for: .editingChanged)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.monthTextField.text?.count == 2 {
                    if self.dayTextField.text == "" {
                        self.dayTextField.becomeFirstResponder()
                    }
                    else {
                        self.view.endEditing(true)
                    }
                }
                self.updateBirthDateIfNeeded()
            })
            .store(in: &cancellables)
        monthTextField.delegate = self

        
        dayTextField.backgroundColor = .mainBackground
        dayTextField.setBorder(borderColor: .mainBackground, borderWidth: 1.0)
        dayTextField.attributedPlaceholder = NSAttributedString(
            string: "30",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white20]
        )
        dayTextField.font = .systemFont(ofSize: 16, weight: .bold)
        dayTextField.textColor = .animalSkyblue
        dayTextField
            .publisher(for: .editingChanged)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.dayTextField.text?.count == 2 {
                    self.view.endEditing(true)
                }
                self.updateBirthDateIfNeeded()
            })
            .store(in: &cancellables)
        dayTextField.delegate = self

        
        signTextField.backgroundColor = .mainBackground
        signTextField.setBorder(borderColor: .mainBackground, borderWidth: 1.0)
        signTextField.attributedPlaceholder = NSAttributedString(
            string: "자동입력",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white20]
        )
        signTextField.font = .systemFont(ofSize: 16, weight: .bold)
        signTextField.textColor = .animalSkyblue
        signTextField.delegate = self
        
        if DeviceInfo.screenWidthRatio > 1 {
            buttonWidthConstraints.forEach {
                $0.constant *= DeviceInfo.screenWidthRatio
            }
            stackViewHeightConstraints.forEach {
                $0.constant *= DeviceInfo.screenWidthRatio
            }
        }
        
    }
    
    private func bindButtons() {
        xButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.showPopupView(
                    alerTitle: "등록을 멈추고 나갈까?",
                    alertMessage: "작성중인 정보는 저장되지 않아.",
                    leftTitle: "취소",
                    rightTitle: "나가기",
                    leftActionHandler: {
                        
                },
                    rightActionHandler: {
                        self?.dismiss(animated: true, completion: nil)
                })
            })
            .store(in: &cancellables)
        
        for (index, button) in bloodTypeButtons.enumerated() {
            button
                .publisher(for: .touchUpInside)
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.updateBloodTypeInfo(buttonNum: index)
                })
                .store(in: &cancellables)
        }
        
        for (index, button) in mbtiButtons.enumerated() {
            button
                .publisher(for: .touchUpInside)
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.updateMBTIBooleanInfos(buttonNum: index)
                })
                .store(in: &cancellables)
        }
        
        for (index, button) in animalButtons.enumerated() {
            button
                .publisher(for: .touchUpInside)
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.updateAnimalInfo(buttonNum: index)
                    self?.animalButtonIndex = index
                })
                .store(in: &cancellables)
        }
        
        mbtiUnknownButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.viewModel.updateMBTItoUnknwon()
            })
            .store(in: &cancellables)
        
        finishButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                if let person = self?.viewModel.registerPerson() {
                    self?.addPersonDelegate?.personRegistered(person: person)
                }
                self?.dismiss(animated: true, completion: nil)
            })
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        bloodTypeSubscription = viewModel.$bloodType
            .sink(receiveValue: { [weak self] bloodType in
                guard let self = self else { return }
                guard let bloodType = bloodType
                else {
                    self.makeButtonSelectedFromArray(buttons: self.bloodTypeButtons, index: BloodType.allCases.count)
                    return
                }
                for index in 0...BloodType.allCases.count {
                    if index == bloodType.rawValue {
                        self.makeButtonSelectedFromArray(buttons: self.bloodTypeButtons, index: index)
                    }
                }
                self.bloodTypeButtons.last?.setTitleColor(.white, for: .normal)
            })
        
        signSubscription = viewModel.$sign
            .sink(receiveValue: { [weak self] sign in
                guard let self = self else { return }
                guard let sign = sign
                else {
                    if self.monthTextField.text != "" && self.dayTextField.text != ""{
                        self.signTextField.text = "잘못된 정보"
                    }
                    return
                }
                self.signTextField.text = sign.koreanName
            })
        
        mbtiSubscription = viewModel.$mbtiButtonBooleanInfos
            .sink(receiveValue: { [weak self] booleanInfos in
                guard let self = self else { return }
                guard booleanInfos.count == 4
                else {
                    self.makeButtonSelected(button: self.mbtiUnknownButton)
                    for button in self.mbtiButtons {
                        self.makeButtonUnselected(button: button)
                    }
                    return
                }
                self.makeButtonUnselected(button: self.mbtiUnknownButton)
                self.mbtiUnknownButton.setBorder(borderColor: .white, borderWidth: 0.0)
                for (index, button) in self.mbtiButtons.enumerated() {
                    if booleanInfos[index / 2] == (index % 2 == 0) {
                        self.makeButtonSelected(button: button)
                    }
                    else {
                        self.makeButtonUnselected(button: button)
                    }
                }
            })
        
        animalIndexSubscription = self.$animalButtonIndex
            .sink(receiveValue: { [weak self] index in
                guard let self = self, let index = index else { return }
                for idx in 0..<Animal.allCases.count {
                    if index == idx {
                        self.makeButtonSelectedFromArray(buttons: self.animalButtons, index: index)
                    }
                }
            })
        
        finishButtonEnableSubscription = viewModel.$personCanbeMade
            .sink(receiveValue: { [weak self] canbeMade in
                guard let self = self else { return }
                canbeMade ? self.makeFinishButtonEnabled() : self.makeFinishButtonDisabled()
            })
        
        personSubscription = viewModel.$person
            .sink(receiveValue: { [weak self] person in
                guard let self = self,
                      let person = person
                else { return }
                self.nameTextField.text = person.name
                var monthString = String(person.birthDate.month)
                if person.birthDate.month / 10 == 0 {
                    monthString = "0" + monthString
                }
                self.monthTextField.text = monthString
                
                var dayString = String(person.birthDate.day)
                if person.birthDate.day / 10 == 0 {
                    dayString = "0" + dayString
                }
                self.dayTextField.text = dayString
                
                for (index, animal) in self.viewModel.animalButtonArray.enumerated() {
                    if animal == person.animal {
                        self.makeButtonSelectedFromArray(buttons: self.animalButtons, index: index)
                    }
                }
            })
        
    }
    
    private func addScrollContainViewGesture() {
        scrollContainView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollContainViewTapped))
        scrollContainView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func scrollContainViewTapped() {
        self.view.endEditing(true)
    }
    
    private func updateBirthDateIfNeeded() {
        guard let month = monthTextField.text,
              let day =  dayTextField.text,
              month.count == 2, day.count == 2
        else { return }
        
        viewModel.updateBirthDate(month: month, day: day)
    }
    
    private func makeButtonSelected(button: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            button.setBorder(borderColor: .white, borderWidth: 1.5)
            button.setTitleColor(.animalSkyblue, for: .normal)
        })
    }
    
    private func makeButtonUnselected(button: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            button.setBorder(borderColor: .white, borderWidth: 0.0)
            button.setTitleColor(.white20, for: .normal)
        })
    }
    
    private func makeButtonSelectedFromArray(buttons: [UIButton], index: Int) {
        for (idx, button) in buttons.enumerated() {
            if index == idx {
                makeButtonSelected(button: button)
            }
            else {
                makeButtonUnselected(button: button)
            }
        }
    }
    
    private func makeFinishButtonEnabled() {
        finishButton.backgroundColor = .animalSkyblue
        finishButton.setTitleColor(.black, for: .normal)
        finishButton.isEnabled = true
    }
    
    private func makeFinishButtonDisabled() {
        finishButton.backgroundColor = .darkGrey
        finishButton.setTitleColor(.white10, for: .normal)
        finishButton.isEnabled = false
    }
}


extension AddPersonViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = .white
        for (index, existTextField) in textFields.enumerated() {
            if existTextField == textField {
                adaptLineViews(withHighLighting: index)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = .animalSkyblue
        adaptLineViews(withHighLighting: -1)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.nameTextField else { return true }
        if NameChecker.shared.chosung.contains(string) || NameChecker.shared.jungsung.contains(string) || NameChecker.shared.jongsung.contains(string) || string.isEmpty {
            return true
        }
        
        self.view.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.showToast(text: "이름은 한글만 입력 가능해!")
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    private func adaptLineViews(withHighLighting highlightIndex: Int) {
        for (index, lineView) in lineViews.enumerated() {
            if index == highlightIndex {
                UIView.animate(withDuration: 0.3, animations: {
                    lineView.backgroundColor = .animalSkyblue
                })
            }
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    lineView.backgroundColor = .white10
                })
            }
        }
    }
    
}
