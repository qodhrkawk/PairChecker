//
//  PeopleListViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit
import Combine

enum MainListSection: Hashable {
    case add
    case person
}

class PeopleListViewController: UIViewController {
    
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var peopleTableView: UITableView!
    
    typealias DataSource = UITableViewDiffableDataSource<MainListSection, Person>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MainListSection, Person>
    private var dataSource: DataSource?
    
    private var peopleSubscription: AnyCancellable?
    
    
    var viewModel = PeopleListViewModel()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        bindViewModel()
        bindButton()
    }
    
    private func prepareUIs() {
        self.view.backgroundColor = .mainBackground
        prepareListTableView()
        
    }
    
    private func bindButton() {
        cardButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .store(in: &cancellables)
    }
    
    private func prepareListTableView() {
        setupDataSource()
        
        peopleTableView.registerCell(cell: MainListTableViewCell.self)
        peopleTableView.registerCell(cell: MainListTableViewAddCell.self)
        peopleTableView.backgroundColor = .mainBackground
        peopleTableView.delegate = self
    }
    
    private func bindViewModel() {
        peopleSubscription = viewModel.$people
            .sink(receiveValue: { [weak self] people in
                self?.updatePeople(people: people)
            })
    }
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: peopleTableView, cellProvider: { [weak self] (tableView, indexPath, person) -> UITableViewCell? in
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTableViewAddCell", for: indexPath) as! MainListTableViewAddCell
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTableViewCell", for: indexPath) as! MainListTableViewCell
                cell.person = person
                return cell
            }
        })
    }
    
    private func updatePeople(people: [Person]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.add, .person])
        snapshot.appendItems([Person(animal: .bear, name: "nil", birthDate: nil, sign: nil, bloodType: nil, mbti: nil)], toSection: .add)
        snapshot.appendItems(people, toSection: .person)
        guard let dataSource = self.dataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}


extension PeopleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deletion = UIContextualAction(style: .normal, title: "삭제") { [weak self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self?.viewModel.deletePerson(index: indexPath.row)
            success(true)
        }
        deletion.backgroundColor = .pastelRed
        
        return UISwipeActionsConfiguration(actions: [deletion])
    }
    
}


