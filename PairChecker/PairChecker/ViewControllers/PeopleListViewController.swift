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
    
    private var personDetailViewController: PersonDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        bindViewModel()
        bindButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.peopleTableView.alpha = 1
            self?.cardButton.alpha = 1
        })
    }
    
    private func prepareUIs() {
        self.view.backgroundColor = .mainBackground
        prepareListTableView()
        
    }
    
    private func bindButton() {
        cardButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.peopleTableView.alpha = 0
                    self?.cardButton.alpha = 0
                }, completion: { [weak self] finished in
                    self?.navigationController?.popViewController(animated: false)
                })
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
        self.dataSource = UITableViewDiffableDataSource(tableView: peopleTableView, cellProvider: { (tableView, indexPath, person) -> UITableViewCell? in
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTableViewAddCell", for: indexPath) as! MainListTableViewAddCell
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTableViewCell", for: indexPath) as! MainListTableViewCell
                cell.person = person
                cell.delegate = self
                return cell
            }
        })
    }
    
    private func updatePeople(people: [Person]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.add, .person])
        snapshot.appendItems([Person(animal: .bear, name: "nil", birthDate: BirthDate(month: 0, day: 0), sign: nil, bloodType: nil, mbti: nil, createdAt: Date())], toSection: .add)
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

extension PeopleListViewController: PeopleListViewDelegate {
    
    func personTapped(person: Person) {
        guard let personDetailViewController = PersonDetailViewController.instantiateFromStoryboard(StoryboardName.personDetail)
        else { return }
        
        personDetailViewController.modalPresentationStyle = .fullScreen
        personDetailViewController.person = person
        personDetailViewController.delegate = self
        navigationController?.present(personDetailViewController, animated: true, completion: nil)
    }
    
    func personRemoved() {
        viewModel.reloadPeople()
    }
    
}


