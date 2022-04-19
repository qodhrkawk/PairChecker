//
//  ResultGraphTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/19.
//

import UIKit

class ResultGraphTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var barContainView: UIView!
    @IBOutlet weak var barView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }

    func prepareUIs() {
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        scoreLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        barContainView.backgroundColor = .paleLilac
        barContainView.makeRounded(cornerRadius: 9)
    }
    
    func setCell(color: UIColor, score: Int?) {
        titleLabel.textColor = color
        scoreLabel.text = score == nil ? "-" : "\(String(score!))점"
    }
    
}
