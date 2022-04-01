//
//  PeopleSelectCollectionViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit

class PeopleSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var person: Person? {
        didSet {
            guard let person = person else { return }
            animalImageView.image = UIImage(named: person.animal.imageName)
            nameLabel.text = person.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }
    
    private func prepareUIs() {
        self.backgroundColor = .mainBackground
        containView.backgroundColor = .white10
        containView.makeRounded(cornerRadius: 36)
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    func transformToLarge() {
        self.nameLabel.font = .systemFont(ofSize: self.nameLabel.font.pointSize, weight: .bold)
        UIView.animate(withDuration: 0.2, animations: {
            self.containView.setBorder(borderColor: .white, borderWidth: 2.0)
        })

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func transformToStandard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containView.setBorder(borderColor: .white, borderWidth: 0.0)
            self.nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        })
    }

}
