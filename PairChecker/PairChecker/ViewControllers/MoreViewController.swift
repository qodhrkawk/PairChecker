//
//  MoreViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/24.
//

import UIKit
import Combine

enum MoreSection: Hashable {
    case main
}

class MoreViewController: UIViewController {
    
    @IBOutlet weak var moreTableView: UITableView!
    @IBOutlet weak var xButton: UIButton!
    
    private var dataSource: DataSource?
    
    typealias DataSource = UITableViewDiffableDataSource<MoreSection, MoreViewItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MoreSection, MoreViewItem>

    private var viewModel = MoreViewModel()
    
    private var moreItemSubscription: AnyCancellable?
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        prepareMoreTableView()
        setupDataSource()
        bindViewModel()
        bindButton()
    }
    
    private func prepareUIs() {
        view.backgroundColor = .mainBackground
    }
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: moreTableView, cellProvider: { (tableView, indexPath, moreItem) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
            cell.setCell(item: moreItem)
            cell.delegate = self
            cell.separatorInset = .zero
            return cell
        })
    }
    
    private func prepareMoreTableView() {
        setupDataSource()
        
        moreTableView.separatorColor = .white20
        moreTableView.registerCell(cell: MoreTableViewCell.self)
        moreTableView.backgroundColor = .mainBackground
        moreTableView.delegate = self
    }
    
    private func updateViewItems(moreViewItems: [MoreViewItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(moreViewItems, toSection: .main)
        guard let dataSource = self.dataSource else { return }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindViewModel() {
        moreItemSubscription = viewModel.$moreViewItems
            .sink(receiveValue: { [weak self] items in
                self?.updateViewItems(moreViewItems: items)
            })
    }
    
    private func bindButton() {
        xButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] in
                self?.dismiss(animated: true)
            })
            .store(in: &cancellables)
    }
}


extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension MoreViewController: MoreViewDelegate {
    func presentViewController(viewControllerName: String) {
        guard let viewController = viewModel.getViewController(of: viewControllerName)
        else { return }
        viewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
