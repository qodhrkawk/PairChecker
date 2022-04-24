//
//  ResultViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/17.
//

import UIKit
import Combine
import SnapKit

enum ResultSection: Hashable {
    case summary
    case detail
}

class ResultViewController: UIViewController {
    @IBOutlet weak var resultTableView: UITableView!
    
    typealias DataSource = UITableViewDiffableDataSource<ResultSection, Bool>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ResultSection, Bool>
    
    private var dataSource: DataSource?
    
    private var cellIndex: Int = 0
    
    var viewModel: PairCheckViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.alpha = 1
        })
    }
    
    private func prepareUIs() {
        view.backgroundColor = .charcoalGrey
        prepareResultTableView()
    }
    
    private func prepareResultTableView() {
        setupDataSource()
        applyTableView()
        
        resultTableView.registerCell(cell: ResultSummaryTableViewCell.self)
        resultTableView.registerCell(cell: ResultDetailTableViewCell.self)
        
        resultTableView.isPagingEnabled = true
        
        resultTableView.delegate = self
    }
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: resultTableView, cellProvider: { [weak self] (tableView, indexPath, person) -> UITableViewCell? in
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSummaryTableViewCell", for: indexPath) as! ResultSummaryTableViewCell
                cell.delegate = self
                cell.viewModel = self?.viewModel
                cell.startAnimation()
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultDetailTableViewCell", for: indexPath) as! ResultDetailTableViewCell
                cell.delegate = self
                cell.viewModel = self?.viewModel
                return cell
            }
        })
    }
    
    private func applyTableView() {
        var snapshot = Snapshot()
        snapshot.appendSections([.summary, .detail])
        snapshot.appendItems([true], toSection: .summary)
        snapshot.appendItems([false], toSection: .detail)
        guard let dataSource = self.dataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            if let cell = resultTableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                cell.frame.origin.y = scrollView.contentOffset.y
                let originalHeight: CGFloat = DeviceInfo.screenHeight
                cell.frame.size.height = originalHeight + scrollView.contentOffset.y * (-1.0)
            }
        }

        if scrollView.contentOffset.y > DeviceInfo.screenHeight * 0.7 {
            if cellIndex == 0 {
                cellIndex = 1
                for cell in resultTableView.visibleCells {
                    if let detailCell = cell as? ResultDetailTableViewCell {
                        detailCell.animateGraphTableView()
                    }
                }
            }
        }
        else {
            if cellIndex == 1 {
                cellIndex = 0
            }
        }
    }
}

extension ResultViewController: ResultViewDelegate {
    func dismissView() {
        UIView.animate(withDuration: 1.0, animations: {
            self.dismiss(animated: false, completion: {
                NotificationCenter.default.post(name: .pairCheckNavigationControllerShouldDismiss, object: nil)
            })
        })
    }
}
