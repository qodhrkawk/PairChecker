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
    
    @IBOutlet var ydiffConstraints: [NSLayoutConstraint]!
    @IBOutlet var heightConstraints: [NSLayoutConstraint]!
    
    
    private var viewModel: CardCollectionViewCellViewModel?
    
    private var personSubscription: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private var floatButtonView = FloatButtonView()
    
    var mainViewDelegate: MainViewDelegate?
    
    private var backCardView = BackCardView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        addContainViewGesture()
        bindResultButton()
    }
    
    override func prepareForReuse() {
        floatButtonView.removeFromSuperview()
        removeBackCardView()
    }

    private func prepareUIs() {
        self.makeRounded(cornerRadius: 35 * DeviceInfo.screenHeightRatio)
        self.containView.makeRounded(cornerRadius: 35 * DeviceInfo.screenHeightRatio)
        
        circleView.makeRounded(cornerRadius: 80 * DeviceInfo.screenHeightRatio)
        circleView.backgroundColor = .circleGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 26 * DeviceInfo.screenHeightRatio, weight: .bold)
        
        resultButton.setTitleColor(.black, for: .normal)
        resultButton.setTitle("궁합보기", for: .normal)
        resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 16 * DeviceInfo.screenHeightRatio, weight: .bold)
        resultButton.makeRounded(cornerRadius: 14)
        
        for ydiffConstraint in ydiffConstraints {
            ydiffConstraint.constant *= DeviceInfo.screenHeightRatio
        }
        
        for heightConstraint in heightConstraints {
            heightConstraint.constant *= DeviceInfo.screenHeightRatio
        }
        
        let editClosure: () -> Void = { [weak self] in
            guard let self = self, let person = self.viewModel?.person else { return }
            self.floatButtonView.removeFromSuperview()
            self.mainViewDelegate?.editPerson(person: person)
        }
        let removeClosure: () -> Void = { [weak self] in
            guard let self = self, let person = self.viewModel?.person else { return }
            self.floatButtonView.removeFromSuperview()
            self.mainViewDelegate?.removePerson(person: person)
        }
        floatButtonView.editClosure = editClosure
        floatButtonView.removeClosure = removeClosure
    }
    
    private func adaptPerson(person: Person) {
        animalImageView.image = UIImage(named: person.animal.imageName)
        resultButton.backgroundColor = person.animal.themeColor.uicolor
        
        nameLabel.text = person.name
        birthLabel.text = person.birthDate.stringFromBrithDate
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
        
        moreButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.showMoreButtonIfNeeded()
                
            })
            .store(in: &cancellables)
    }
    
    
    @objc func containViewTapped() {
        guard let viewModel = viewModel else { return }
        self.floatButtonView.removeFromSuperview()
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)

        if viewModel.front {
            addBackCardView()
            viewModel.front = false
        }
        else {
            removeBackCardView()
            viewModel.front = true
        }
    }
    
    private func showMoreButtonIfNeeded() {
        guard floatButtonView.superview == nil
        else {
            floatButtonView.removeFromSuperview()
            return
        }
        
        self.addSubview(floatButtonView)
        floatButtonView.alpha = 0
        self.floatButtonView.snp.remakeConstraints { [weak self] make in
            guard let self = self else { return }
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(self.moreButton.snp.bottom)
            make.width.equalTo(144)
            make.height.equalTo(98)
        }
        
        self.floatButtonView.transform = CGAffineTransform.identity.translatedBy(x: 50, y: -50).scaledBy(x: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.floatButtonView.alpha = 1
            self?.floatButtonView.transform = .identity
        })
    }

    private func addBackCardView() {
        backCardView.person = self.viewModel?.person
        self.containView.addSubview(backCardView)
        backCardView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(58 * DeviceInfo.screenHeightRatio)
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
