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
    
    @IBOutlet var bloodTypeButtons: [UIButton]!
    @IBOutlet var mbtiButtons: [UIButton]!
    @IBOutlet weak var mbtiUnknownButton: UIButton!
    @IBOutlet var animalButtons: [UIButton]!
    
    
    @IBOutlet weak var finishButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        bindButtons()

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
        }
        
        for mbtiButton in mbtiButtons {
            mbtiButton.backgroundColor = .charcoalGrey
            mbtiButton.setTitleColor(.white, for: .normal)
            mbtiButton.makeRounded(cornerRadius: 14)

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
                if self.monthTextField.text?.count == 2 && self.dayTextField.text == "" {
                    self.dayTextField.becomeFirstResponder()
                }
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
                if self.dayTextField.text?.count == 2{
                    self.view.endEditing(true)
                    self.calculateSignFromDate()
                }
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

    }
    
    private func bindButtons() {
        xButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .store(in: &cancellables)
    }
    
    private func calculateSignFromDate() {
        guard let monthString = self.monthTextField.text,
              let dayString = self.dayTextField.text,
              let month = Int(monthString),
              let day = Int(dayString),
              month > 0, month < 13, day > 0, day < 32
        else { return }
        let sign = SignChecker.shared.getSignFromDate(month: month, day: day)
        
        signTextField.text = sign.koreanName
    }


}


extension AddPersonViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
}
