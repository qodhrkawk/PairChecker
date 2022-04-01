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
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var highLightImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
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
            .sink(receiveValue: { _ in
                guard let peopleListViewController = PeopleListViewController.instantiateFromStoryboard(StoryboardName.peopleList) else { return }
                self.navigationController?.pushViewController(peopleListViewController, animated: true)
                
            })
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        cardCollectionView.registerCell(cell: CardCollectionViewCell.self)
        cardCollectionView.registerCell(cell: CardCollectionViewBackCell.self)
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
                self.mainTextLabel.text = mainText.text
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
            guard person.front else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewBackCell", for: indexPath) as! CardCollectionViewBackCell
                cell.setViewModel(viewModel: CardCollectionViewBackCellViewModel(person: person))
                if self.viewModel.frontModifedIndex != -1 && self.viewModel.frontModifedIndex == indexPath.row {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(0), execute: {
                        UIView.transition(with: cell, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    })
//                    Thread.sleep(forTimeInterval: 0.4)
                    self.viewModel.frontModifedIndex = -1
                }
                cell.mainViewDelegate = self
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
            cell.setViewModel(viewModel: CardCollectionViewCellViewModel(person: person))
            if self.viewModel.frontModifedIndex != -1 && self.viewModel.frontModifedIndex == indexPath.row {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(0), execute: {
                    UIView.transition(with: cell, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                })
//                Thread.sleep(forTimeInterval: 0.4)
                self.viewModel.frontModifedIndex = -1
            }
            cell.mainViewDelegate = self
            return cell
        })
    }
    
    private func updatePeople(people: [Person]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(people)
        guard let dataSource = self.dataSource else {
            return
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UIScrollViewDelegate {
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
}

extension MainViewController: MainViewDelegate {
    func check(person: Person) {
        guard let personSelectViewController = PersonSelectViewController.instantiateFromStoryboard(StoryboardName.personSelect) else { return }
        personSelectViewController.viewModel.mainPerson = person
        personSelectViewController.modalPresentationStyle = .fullScreen
        self.present(personSelectViewController, animated: true, completion: nil)
    }
}
