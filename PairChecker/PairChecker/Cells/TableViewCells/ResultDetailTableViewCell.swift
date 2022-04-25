//
//  ResultDetailTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/17.
//

import UIKit
import Combine

enum ResultDetailSection: Hashable {
    case main
}

class ResultDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var graphTableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    typealias DataSource = UITableViewDiffableDataSource<ResultDetailSection, ResultGraphElement>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ResultDetailSection, ResultGraphElement>
    
    private var dataSource: DataSource?
    weak var delegate: ResultViewDelegate?
    
    var viewModel: PairCheckViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private var totalScoreSubscription: AnyCancellable?
    private var graphElementsSubscription: AnyCancellable?
    private var commentTextSubscription: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        bindButton()
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
        
        prepareGraphTableView()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        totalScoreSubscription = viewModel.$averageScore
            .sink(receiveValue: { [weak self] score in
                self?.scoreLabel.text = String(score)
            })
        
        graphElementsSubscription = viewModel.$graphElements
            .sink(receiveValue: { [weak self] graphElements in
                self?.applyTableView(graphElements: graphElements)
            })
        
        
        commentTextSubscription = viewModel.$secondResultText
            .sink(receiveValue: { [weak self] text in
                self?.commentTextView.setTextWithLineSpacing(text: text, spacing: 5, font: .systemFont(ofSize: 14))
            })
        
    }
    
    private func prepareGraphTableView() {
        setupDataSource()
        
        graphTableView.registerCell(cell: ResultGraphTableViewCell.self)
                
        graphTableView.delegate = self
    }
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: graphTableView, cellProvider: { (tableView, indexPath, graphElement) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultGraphTableViewCell", for: indexPath) as! ResultGraphTableViewCell

            cell.setCell(graphElement: graphElement)
            return cell
            
        })
    }
    
    private func applyTableView(graphElements: [ResultGraphElement]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(graphElements, toSection: .main)
        guard let dataSource = self.dataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func bindButton() {
        finishButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.delegate?.dismissView()
            })
            .store(in: &cancellables)
    }
    
    func animateGraphTableView() {
        graphTableView.visibleCells.forEach { cell in
            guard let graphCell = cell as? ResultGraphTableViewCell else { return }
            graphCell.barAnimate()
        }
    }
}


extension ResultDetailTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        66
    }
}
