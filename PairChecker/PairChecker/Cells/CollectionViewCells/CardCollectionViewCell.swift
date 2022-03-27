//
//  CardCollectionViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/05.
//

import UIKit
import Combine

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    
    private var viewModel: CardCollectionViewCellViewModel?
    private var personSubscription: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        addContainViewGesture()
        
    }

    private func prepareUIs() {
        self.makeRounded(cornerRadius: 35)
        
        circleView.makeRounded(cornerRadius: 80)
        circleView.backgroundColor = .circleGray
        
        animalImageView.image = UIImage(named: "frog")

        nameLabel.text = "이예슬"
        nameLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        birthLabel.text = "98.05.01"
        
        resultButton.setTitleColor(.black, for: .normal)
        resultButton.setTitle("궁합보기", for: .normal)
        resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        resultButton.makeRounded(cornerRadius: 14)
    }
    
    private func adaptAnimal(animal: Animal) {
        animalImageView.image = UIImage(named: animal.imageName)
        resultButton.backgroundColor = animal.themeColor.uicolor
    }
    
    private func addContainViewGesture() {
        containView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containViewTapped))
        containView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func containViewTapped() {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        NotificationCenter.default.post(name: .didTapCurrentIndex, object: nil)
    }

    
    func setViewModel(viewModel: CardCollectionViewCellViewModel) {
        self.viewModel = viewModel
        personSubscription = viewModel.$person
            .sink(receiveValue: { [weak self] person in
                guard let self = self else { return }
                self.adaptAnimal(animal: person.animal)
            })
    }

}
