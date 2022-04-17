//
//  ResultViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/17.
//

import UIKit
import Combine

enum ResultSection: Hashable {
    case summary
    case detail
}

class ResultViewController: UIViewController {
    @IBOutlet weak var resultTableView: UITableView!
    
    typealias DataSource = UITableViewDiffableDataSource<ResultSection, Bool>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ResultSection, Bool>
    
    private var dataSource: DataSource?
    
    private var lastContentOffset: CGFloat = 0
    private var cellIndex: Int = 0
    
    var viewModel: PairCheckViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
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
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultDetailTableViewCell", for: indexPath) as! ResultDetailTableViewCell
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
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > self.lastContentOffset && cellIndex != 1 {
//            self.resultTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
//            self.cellIndex = 1
//        }
//        else if cellIndex != 0 {
//            self.resultTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//            self.cellIndex = 0
//        }
//        lastContentOffset = scrollView.contentOffset.y
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            if let cell = resultTableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                cell.frame.origin.y = scrollView.contentOffset.y
                let originalHeight: CGFloat = DeviceInfo.screenHeight
                cell.frame.size.height = originalHeight + scrollView.contentOffset.y * (-1.0)
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
