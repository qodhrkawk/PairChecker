//
//  CardCollectionViewBackCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/26.
//

import UIKit
import Combine

class CardCollectionViewBackCell: UICollectionViewCell {
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var infoLabels: [UILabel]!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var resultButton: UIButton!
    
    var mainViewDelegate: MainViewDelegate?
    
    private var cancellables = Set<AnyCancellable>()

    
    private var viewModel: CardCollectionViewBackCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            resultButton.backgroundColor = viewModel.person.animal.themeColor.uicolor
            for (index, infoLabel) in infoLabels.enumerated() {
                infoLabel.font = .systemFont(ofSize: 20, weight: .bold)
                switch index {
                case 0: infoLabel.text = viewModel.person.name
                case 1: infoLabel.text = viewModel.person.birthDate
                case 2: infoLabel.text = viewModel.person.sign?.koreanName ?? "-"
                case 3: infoLabel.text = viewModel.person.bloodType?.koreanName ?? "-"
                default:
                    guard let mbti = viewModel.person.mbti else {
                        infoLabel.text = "-"
                        return
                    }
                    infoLabel.text = "\(mbti)"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        addContainViewGesture()
    }
    
    private func prepareUIs() {
        for titleLabel in titleLabels {
            titleLabel.textColor = .textblack
            titleLabel.alpha = 0.4
        }
        self.makeRounded(cornerRadius: 35)
        containView.makeRounded(cornerRadius: 35)
        
        resultButton.setTitleColor(.black, for: .normal)
        resultButton.setTitle("궁합보기", for: .normal)
        resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        resultButton.makeRounded(cornerRadius: 14)
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
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        NotificationCenter.default.post(name: .didTapCurrentIndex, object: nil)
    }

    
    func setViewModel(viewModel: CardCollectionViewBackCellViewModel) {
        self.viewModel = viewModel
    }

}
