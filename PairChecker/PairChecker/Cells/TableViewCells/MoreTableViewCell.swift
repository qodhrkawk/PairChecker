//
//  MoreTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/24.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewControllerName: String?
    weak var delegate: MoreViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        setGesture()
    }
    
    func setCell(item: MoreViewItem) {
        titleLabel.text = item.viewName
        viewControllerName = item.viewControllerName
    }
    
    private func setGesture() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containViewTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func containViewTapped() {
        guard let viewControllerName = viewControllerName else { return }
        delegate?.presentViewController(viewControllerName: viewControllerName)
    }
    
}
