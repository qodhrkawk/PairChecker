//
//  MainListTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit
import Combine

class MainListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    
    weak var delegate: PeopleListViewDelegate?
    
    var person: Person? {
        didSet {
            guard let person = person else { return }
            self.animalImageView.image = UIImage(named: person.animal.imageName)
            self.nameLabel.text = person.name
            self.birthDateLabel.text = person.birthDate.stringFromBrithDate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        setGesture()
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
    
    private func setGesture() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containViewTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func containViewTapped() {
        guard let person = person else { return }
        delegate?.personTapped(person: person)
    }
}
