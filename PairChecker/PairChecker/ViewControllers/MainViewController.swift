//
//  MainViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/05.
//

import UIKit
import Combine

enum MainCardSection: Hashable {
    case main
    case empty
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var highLightImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet var yDiffConstraints: [NSLayoutConstraint]!
    
    let colors = [UIColor.red, UIColor.green, UIColor.blue]
    
    private let viewModel = MainViewModel()
    
    private var mainTextSubscription: AnyCancellable?
    private var peopleSubscription: AnyCancellable?
    private var themeColorSubscription: AnyCancellable?
    
    private var dataSource: DataSource?
    typealias DataSource = UICollectionViewDiffableDataSource<MainCardSection, Person>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MainCardSection, Person>
    
    var cancellables = Set<AnyCancellable>()
    
    private var people: [Person] = []
    var currentIndex: CGFloat = 0.0
    
    private var centerCell: CardCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUIs()
        setupCollectionView()
        setupDataSource()
        bindViewModel()
        bindButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reloadPeople()
        viewModel.makeRandomMainText()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.cardCollectionView.alpha = 1
            self?.highlightCenterCell()
            self?.mainTextLabel.alpha = 1
            self?.addButton.alpha = 1
            self?.listButton.alpha = 1
            if self?.viewModel.mainText == .heart {
                self?.circleImageView.alpha = 1
            }
            else {
                self?.highLightImageView.alpha = 1
            }
        },completion: { [weak self] _ in
            self?.highlightCenterCell()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: { [weak self] in
            self?.highlightCenterCell()
        })
    }
    
    private func prepareUIs() {
        view.backgroundColor = .mainBackground
        
        mainTextLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        mainTextLabel.textColor = .white
        
        addButton.setImage(UIImage(named: "btnMainNew"), for: .normal)
    }
    
    private func bindButton() {
        listButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let peopleListViewController = PeopleListViewController.instantiateFromStoryboard(StoryboardName.peopleList) else { return }
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.cardCollectionView.alpha = 0
                    self?.mainTextLabel.alpha = 0
                    self?.highLightImageView.alpha = 0
                    self?.circleImageView.alpha = 0
                    self?.addButton.alpha = 0
                    self?.listButton.alpha = 0
                },completion: { [weak self] _ in
                    self?.navigationController?.pushViewController(peopleListViewController, animated: false)
                })
                
            })
            .store(in: &cancellables)
        
        addButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let addPersonViewController = AddPersonViewController.instantiateFromStoryboard(StoryboardName.addPerson)
                else { return }
                addPersonViewController.modalPresentationStyle = .fullScreen
                
                self?.navigationController?.present(addPersonViewController, animated: true, completion: nil)
            })
            .store(in: &cancellables)
        
        moreButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let moreViewController = MoreViewController.instantiateFromStoryboard(StoryboardName.more)
                else { return }
                moreViewController.modalPresentationStyle = .fullScreen
                
                self?.navigationController?.present(moreViewController, animated: true, completion: nil)
            })
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        cardCollectionView.registerCell(cell: CardCollectionViewCell.self)
        cardCollectionView.registerCell(cell: EmptyCardCollectionViewCell.self)
        cardCollectionView.backgroundColor = .mainBackground
        
        cardCollectionView.decelerationRate = .fast
        cardCollectionView.isPagingEnabled = false
        
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 111
        let cellHeight: CGFloat = cardCollectionView.frame.height
        
        let layout = cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 24.0
        layout.scrollDirection = .horizontal
        cardCollectionView.contentInset = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 56)
        cardCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        cardCollectionView.delegate = self
    }
    
    private func bindViewModel() {
        mainTextSubscription = viewModel.$mainText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] mainText in
                guard let self = self else { return }
                self.mainTextLabel.setTextWithLineSpacing(text: mainText.text, spacing: 4)
                if mainText == .heart {
                    self.circleImageView.alpha = 1
                    self.highLightImageView.alpha = 0
                }
                else {
                    self.highLightImageView.alpha = 1
                    self.circleImageView.alpha = 0
                }
            })

        peopleSubscription = viewModel.$people
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] people in
                self?.updatePeople(people: people)
                self?.people = people
            })
        
        themeColorSubscription = viewModel.$mainColor
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] color in
                guard let self = self else { return }
                self.highLightImageView.image = UIImage(named: color.highlightImageString)
                self.circleImageView.image = UIImage(named: color.highlightCircleString)
            })
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: cardCollectionView, cellProvider: { [weak self] (collectionView, indexPath, person) -> UICollectionViewCell? in
            guard let self = self else { return UICollectionViewCell() }
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
                cell.setViewModel(viewModel: CardCollectionViewCellViewModel(person: person))
                cell.mainViewDelegate = self
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCardCollectionViewCell", for: indexPath) as! EmptyCardCollectionViewCell
                return cell
            }
        })
    }
    
    private func updatePeople(people: [Person]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main,.empty])
        guard people.count != 0 else {
            snapshot.appendItems([Person.dummyPersonForSection], toSection: .empty)
            guard let dataSource = self.dataSource else { return }
            dataSource.apply(snapshot, animatingDifferences: true)
            return
        }
        snapshot.appendItems(people, toSection: .main)
        guard let dataSource = self.dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func highlightCenterCell() {
        let centerPoint = CGPoint(x: self.cardCollectionView.frame.size.width / 2 + self.cardCollectionView.contentOffset.x,
                                  y: self.cardCollectionView.frame.size.height / 2 + self.cardCollectionView.contentOffset.y)

        guard let indexPath = self.cardCollectionView.indexPathForItem(at: centerPoint) else { return }
        let newCenterCell = self.cardCollectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
                
        self.centerCell = newCenterCell

        self.cardCollectionView.cellForItem(at: IndexPath(item: indexPath.item + 1, section: 0))?.alpha = 0.4
        self.cardCollectionView.cellForItem(at: IndexPath(item: indexPath.item - 1, section: 0))?.alpha = 0.1
        self.centerCell?.alpha = 1.0
    }
}

extension MainViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == cardCollectionView {
            let layout = self.cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            var roundedIndex = round(index)
            
            if scrollView.contentOffset.x > targetContentOffset.pointee.x {
                roundedIndex = floor(index)
            } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
                roundedIndex = ceil(index)
            }
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
            viewModel.updateCurrentIndex(index: Int(currentIndex))
            
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
            targetContentOffset.pointee = offset
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        highlightCenterCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        highlightCenterCell()
    }
}

extension MainViewController: MainViewDelegate {
    func check(person: Person) {
        guard let pairCheckNavigationController = PairCheckNavigationController.instantiateFromStoryboard(StoryboardName.pairCheck) else { return }
        
        pairCheckNavigationController.modalPresentationStyle = .fullScreen
        pairCheckNavigationController.viewModel.addMainPerson(person: person)
        self.present(pairCheckNavigationController, animated: true, completion: nil)
    }
    
    func editPerson(person: Person) {
        guard let addPersonViewController = AddPersonViewController.instantiateFromStoryboard(StoryboardName.addPerson)
        else { return }
        addPersonViewController.modalPresentationStyle = .fullScreen
        addPersonViewController.viewModel.person = person
        
        self.navigationController?.present(addPersonViewController, animated: true, completion: nil)
    }
    
    func removePerson(person: Person) {
        self.showPersonDeletePopup(person: person, deleteCompletion: { [weak self] in
            self?.viewModel.reloadPeople()
        })
    }
}
