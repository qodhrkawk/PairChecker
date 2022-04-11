//
//  CardCollectionViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/05.
//

import UIKit
import Combine
import SnapKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    private var viewModel: CardCollectionViewCellViewModel?
    private var personSubscription: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    var mainViewDelegate: MainViewDelegate?
    
    private var backCardView = BackCardView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        addContainViewGesture()
        bindResultButton()
    }

    private func prepareUIs() {
        self.makeRounded(cornerRadius: 35)
        self.containView.makeRounded(cornerRadius: 35)
        
        circleView.makeRounded(cornerRadius: 80)
        circleView.backgroundColor = .circleGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        resultButton.setTitleColor(.black, for: .normal)
        resultButton.setTitle("궁합보기", for: .normal)
        resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        resultButton.makeRounded(cornerRadius: 14)

    }
    
    private func adaptPerson(person: Person) {
        animalImageView.image = UIImage(named: person.animal.imageName)
        resultButton.backgroundColor = person.animal.themeColor.uicolor
        
        nameLabel.text = person.name
        birthLabel.text = person.birthDate?.stringFromBrithDate ?? ""
    }
    
    private func addContainViewGesture() {
        containView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containViewTapped))
        containView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func bindResultButton() {
        resultButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self,
                      let person = self.viewModel?.person
                else { return }
                self.mainViewDelegate?.check(person: person)
            })
            .store(in: &cancellables)
    }
    
    
    @objc func containViewTapped() {
        guard let viewModel = viewModel else { return }
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)

        if viewModel.person.front {
            addBackCardView()
            viewModel.person.front = false
        }
        else {
            removeBackCardView()
            viewModel.person.front = true
        }
    }

    private func addBackCardView() {
        backCardView.person = self.viewModel?.person
        self.containView.addSubview(backCardView)
        backCardView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(resultButton.snp.top)
        }
        self.circleView.alpha = 0
    }
    
    private func removeBackCardView() {
        backCardView.removeFromSuperview()
        self.circleView.alpha = 1
    }
    
    func setViewModel(viewModel: CardCollectionViewCellViewModel) {
        self.viewModel = viewModel
        personSubscription = viewModel.$person
            .sink(receiveValue: { [weak self] person in
                guard let self = self else { return }
                self.adaptPerson(person: person)
            })
    }

}
