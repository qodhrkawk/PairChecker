//
//  MainListTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit

class MainListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    
    var person: Person? {
        didSet {
            guard let person = person else { return }
            self.animalImageView.image = UIImage(named: person.animal.imageName)
            self.nameLabel.text = person.name
            self.birthDateLabel.text = person.birthDate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepareUIs() {
        self.backgroundColor = .mainBackground
        
        circleView.makeRounded(cornerRadius: 28)
        circleView.backgroundColor = .white10
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        birthDateLabel.textColor = .white
        birthDateLabel.alpha = 0.5
        birthDateLabel.font = .systemFont(ofSize: 14)
    }
    
}
