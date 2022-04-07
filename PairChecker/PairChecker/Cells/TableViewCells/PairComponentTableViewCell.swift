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
    
    var delegate: PairComponentTableViewCellDelegate?
    
    var componentModel: PairCheckComponentModel? {
        didSet {
            guard let model = componentModel else { return }
            titleLabel.text = model.component.title
            subTitleLabel.text = model.component.subTitle
            adaptToSelection()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        addContainViewGesture()
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
        
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .white
        subTitleLabel.alpha = 0.4
    }
    
    private func adaptToSelection() {
        guard let componentModel = componentModel else { return }

        if componentModel.selected {
            self.containView.setBorder(borderColor: componentModel.component.uiColor, borderWidth: 1.5)
        }
        else {
            self.containView.setBorder(borderColor: .mainBackground, borderWidth: 0)
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
