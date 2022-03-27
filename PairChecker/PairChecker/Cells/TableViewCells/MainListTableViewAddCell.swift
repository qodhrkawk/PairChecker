//
//  MainListTableViewAddCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit

class MainListTableViewAddCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func prepareUIs() {
        self.backgroundColor = .mainBackground
    }
    
}
