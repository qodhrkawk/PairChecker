//
//  MainListTableViewAddCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit

class MainListTableViewAddCell: UITableViewCell {
    
    weak var delegate: PeopleListViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        setGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func prepareUIs() {
        self.backgroundColor = .mainBackground
    }
    
    private func setGesture() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containViewTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func containViewTapped() {
        delegate?.addCellTapped()
    }
    
}
