//
//  EmptyCardCollectionViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/23.
//

import UIKit

class EmptyCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }
    
    private func prepareUIs() {
        self.makeRounded(cornerRadius: 35)
        containView.makeRounded(cornerRadius: 35)
        
        containView.backgroundColor = .white10
    }

}
