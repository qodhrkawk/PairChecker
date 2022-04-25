//
//  PairComponentTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/04.
//

import UIKit

class PairComponentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var highlightImageView: UIImageView!
    @IBOutlet weak var unavailableImageView: UIImageView!
    
    var delegate: PairComponentTableViewCellDelegate?
    
    @IBOutlet weak var highlightTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var highlightLeadingConstraint: NSLayoutConstraint!
    
    var componentModel: PairCheckComponentModel? {
        didSet {
            guard let model = componentModel else { return }
            titleLabel.text = model.component.title
            subTitleLabel.text = model.component.subTitle
            highlightImageView.image = model.component.highlightImage
            
            if model.component == .name || model.component == .mbti {
                highlightTopConstraint.constant = 17
                highlightLeadingConstraint.constant = 18
            }
            
            adaptToSelection()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        addContainViewGesture()
        adaptToSelection()
//        adapToAvailability()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func prepareUIs() {
        self.backgroundColor = .mainBackground
        containView.backgroundColor = .cellgray
        containView.makeRounded(cornerRadius: 20)
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        
        highlightImageView.alpha = 0
        
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .white
        subTitleLabel.alpha = 0.4
        
        unavailableImageView.alpha = 0
    }
        
    func adaptToSelection() {
        guard let componentModel = componentModel else { return }

        if componentModel.selected && componentModel.available {
            self.containView.setBorder(borderColor: .white, borderWidth: 1.5)
            highlightImageView.alpha = 1
        }
        else if !componentModel.selected && componentModel.available{
            self.containView.setBorder(borderColor: .mainBackground, borderWidth: 0)
            highlightImageView.alpha = 0
        }
        else {
            containView.backgroundColor = .darkGrey
            unavailableImageView.alpha = 1
            containView.isUserInteractionEnabled = false
            subTitleLabel.text = "프로필 정보가 부족해서 볼 수 없어!"
        }
    }
    
    private func addContainViewGesture() {
        containView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containViewTapped))
        containView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func containViewTapped() {
        guard let componentModel = componentModel else { return }
        self.componentModel?.selected = !componentModel.selected
        delegate?.componentIsTapped(component: componentModel.component)
        
        adaptToSelection()
    }
    
}
