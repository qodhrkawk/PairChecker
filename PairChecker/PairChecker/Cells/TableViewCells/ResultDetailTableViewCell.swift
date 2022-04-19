//
//  ResultDetailTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/17.
//

import UIKit
import Combine

class ResultDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var graphTableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var viewModel: PairCheckViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private var totalScoreSubscription: AnyCancellable?
    private var scoreArraySubscription: AnyCancellable?
    private var commentTextSubscription: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }

    private func prepareUIs() {
        for titleLabel in titleLabels {
            titleLabel.font = UIFont(name: "GmarketSansBold", size: 16)
        }
        
        scoreLabel.font = UIFont(name: "GmarketSansBold", size: 50)
        
        graphTableView.backgroundColor = .clear
        
        commentTextView.backgroundColor = .clear
        commentTextView.font = .systemFont(ofSize: 14)
        commentTextView.textContainerInset = UIEdgeInsets.zero
        commentTextView.textContainer.lineFragmentPadding = 0
        
        finishButton.setTitle("메인으로", for: .normal)
        finishButton.makeRounded(cornerRadius: 14)
        finishButton.backgroundColor = .animalGreen
        finishButton.setTitleColor(.black, for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        totalScoreSubscription = viewModel.$averageScore
            .sink(receiveValue: { [weak self] score in
                self?.scoreLabel.text = String(score)
            })
        
        
        commentTextSubscription = viewModel.$secondResultText
            .sink(receiveValue: { [weak self] text in
                let style = NSMutableParagraphStyle()
                let font = UIFont.systemFont(ofSize: 14)
                style.lineSpacing = 5
                let attributes = [NSAttributedString.Key.paragraphStyle: style,
                                  NSAttributedString.Key.font: font
                ]
                self?.commentTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
            })
        
    }
    
    
    
}
