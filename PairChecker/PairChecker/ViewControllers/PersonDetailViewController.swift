//
//  PersonDetailViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/11.
//

import UIKit
import Combine

class PersonDetailViewController: UIViewController {
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var imageContainView: UIView!
    @IBOutlet weak var animalImageView: UIImageView!
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var contentLabels: [UILabel]!
    @IBOutlet weak var pairButton: UIButton!

    private var floatButtonView = FloatButtonView()
    
    weak var delegate: PeopleListViewDelegate?
    
    var person: Person?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        prepareFloatButtonView()
        bindButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideFloatButtonView()
    }
    
    private func prepareUIs() {
        view.backgroundColor = .mainBackground
        
        imageContainView.backgroundColor = .white10
        imageContainView.makeRounded(cornerRadius: 111 / 2)
        
        for titleLabel in titleLabels {
            titleLabel.font = .systemFont(ofSize: 14)
            titleLabel.textColor = .white
            titleLabel.alpha = 0.4
        }
        
        for contentLabel in contentLabels {
            contentLabel.font = .systemFont(ofSize: 20, weight: .bold)
            contentLabel.textColor = .white
        }
        
        pairButton.makeRounded(cornerRadius: 14)
        pairButton.setTitleColor(.black, for: .normal)
        pairButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        guard let person = person else { return }
        adaptPerson(person: person)
    }
    
    private func adaptPerson(person: Person) {
        animalImageView.image = UIImage(named: person.animal.imageName)
        contentLabels[0].text = person.name
        contentLabels[1].text = person.birthDate.stringFromBrithDate
        contentLabels[2].text = person.sign?.koreanName ?? "-"
        contentLabels[3].text = person.bloodType?.koreanName ?? "-"
        contentLabels[4].text = person.mbti?.stringName ?? "-"
        pairButton.backgroundColor = person.animal.themeColor.uicolor
    }
    
    private func bindButtons() {
        xButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .store(in: &cancellables)
        moreButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.showFloatButtonView()
            })
            .store(in: &cancellables)
        
        pairButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.pairCheck()
            })
            .store(in: &cancellables)
        
    }
    
    private func prepareFloatButtonView() {
        let editClosure: () -> Void = { [weak self] in
            guard let self = self, let person = self.person else { return }
            self.hideFloatButtonView()
            self.showEditViewController()
        }
        let removeClosure: () -> Void = { [weak self] in
            guard let self = self, let person = self.person else { return }
            self.hideFloatButtonView()
            self.showPersonDeletePopup(person: person, deleteCompletion: { [weak self] in
                self?.delegate?.personRemoved()
                self?.dismiss(animated: true, completion: nil)
            })
        }
        floatButtonView.editClosure = editClosure
        floatButtonView.removeClosure = removeClosure
    }
    
    private func showFloatButtonView() {
        view.addSubview(self.floatButtonView)
        floatButtonView.alpha = 0
        floatButtonView.snp.remakeConstraints { [weak self] make in
            guard let self = self else { return }
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.moreButton.snp.bottom).offset(10)
            make.width.equalTo(144)
            make.height.equalTo(98)
        }
        
        self.floatButtonView.transform = CGAffineTransform.identity.translatedBy(x: 50, y: -50).scaledBy(x: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.floatButtonView.alpha = 1
            self?.floatButtonView.transform = .identity
        })
    }
    
    private func hideFloatButtonView() {
        self.floatButtonView.removeFromSuperview()
    }
    
    private func showEditViewController() {
        guard let addPersonViewController = AddPersonViewController.instantiateFromStoryboard(StoryboardName.addPerson)
        else { return }
        addPersonViewController.modalPresentationStyle = .fullScreen
        addPersonViewController.viewModel.person = person
        addPersonViewController.addPersonDelegate = self
        
        self.present(addPersonViewController, animated: true, completion: nil)
    }
    
    private func pairCheck() {
        guard let pairCheckNavigationController = PairCheckNavigationController.instantiateFromStoryboard(StoryboardName.pairCheck),
              let person = self.person
        else { return }

        pairCheckNavigationController.modalPresentationStyle = .fullScreen
        pairCheckNavigationController.viewModel.addMainPerson(person: person)
        self.present(pairCheckNavigationController, animated: true, completion: nil)
    }

}

extension PersonDetailViewController: AddPersonDelegate {
    func personRegistered(person: Person) {
        self.person = person
        self.adaptPerson(person: person)
    }
}


