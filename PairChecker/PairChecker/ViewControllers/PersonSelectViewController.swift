//
//  PersonSelectViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit
import Combine

enum PersonSelectSection: Hashable {
    case person
}

class PersonSelectViewController: UIViewController {
    
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var grayCircleView: UIView!
    @IBOutlet weak var pivotPersonImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectionImage: UIImageView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<PersonSelectSection, Person>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PersonSelectSection, Person>

    private var dataSource: DataSource?

    private var peopleSubscription: AnyCancellable?
    private var mainAnimalSubscription: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: PairCheckViewModel?
    
    private var centerCell: PeopleSelectCollectionViewCell?
    private var centerIndex: Int = -1
    private var previousIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        prepareCollectionView()
        bindViewModel()
        bindButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        highlightCenterCell(canfromSameIndex: false)
    }
    
    private func prepareUIs() {
        view.backgroundColor = .mainBackground
        
        grayCircleView.makeRounded(cornerRadius: 36)
        grayCircleView.backgroundColor = .white10
        
        titleLabel.text = "누구와의 궁합을\n확인해 볼까?😎"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
        
        subTitleLabel.text = "상대 프로필을 슬라이드해서 찾아봐!"
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .white
        subTitleLabel.alpha = 0.4
        
        selectButton.makeRounded(cornerRadius: 14)
        selectButton.setTitle("선택완료", for: .normal)
        selectButton.setTitleColor(.black, for: .normal)
        selectButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        selectionImage.image = UIImage(named: "imgSelectedProfile")?.withRenderingMode(.alwaysTemplate)
    }
    
    private func bindViewModel() {
        if let navigationController = self.navigationController as? PairCheckNavigationController {
            self.viewModel = navigationController.viewModel
        }

        guard let viewModel = self.viewModel else { return }

        peopleSubscription = viewModel.$people
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] people in
                guard let self = self else { return }
                self.updatePeople(people: people)
            })
        
        mainAnimalSubscription = viewModel.$mainAnimal
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] animal in
                guard let self = self,
                      let animal = animal
                else { return }
                self.selectButton.backgroundColor = animal.themeColor.uicolor
                self.selectionImage.tintColor = animal.themeColor.uicolor
                self.pivotPersonImageView.image = UIImage(named: animal.imageName)
            })
    }
    
    private func bindButtons() {
        xButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .store(in: &cancellables)
        
        selectButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let pairComponentSelectViewController = PairComponentSelectViewController.instantiateFromStoryboard(StoryboardName.pairCheck) else { return }
                pairComponentSelectViewController.viewModel = self?.viewModel
                self?.navigationController?.pushViewController(pairComponentSelectViewController, animated: true)
            })
            .store(in: &cancellables)
    }
    
    private func prepareCollectionView() {
        peopleCollectionView.backgroundColor = .mainBackground
        peopleCollectionView.registerCell(cell: PeopleSelectCollectionViewCell.self)
        
        peopleCollectionView.decelerationRate = .fast
        peopleCollectionView.delegate = self
        
        let flowLayout = PeopleSelectionCollectionViewFlowLayout()
        peopleCollectionView.collectionViewLayout = flowLayout
        peopleCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        
        let layoutMargins: CGFloat = peopleCollectionView.layoutMargins.left + peopleCollectionView.layoutMargins.right
        let sideInset = self.view.frame.width / 2 - layoutMargins
        peopleCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        setupDataSource()
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: peopleCollectionView, cellProvider: { (collectionView, indexPath, person) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleSelectCollectionViewCell", for: indexPath) as! PeopleSelectCollectionViewCell
            cell.person = person
            
            return cell
        })
    }
    
    private func updatePeople(people: [Person]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.person])
        snapshot.appendItems(people)
        guard let dataSource = self.dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func highlightCenterCell(canfromSameIndex: Bool) {
        let centerPoint = CGPoint(x: self.peopleCollectionView.frame.size.width / 2 + self.peopleCollectionView.contentOffset.x,
                                  y: self.peopleCollectionView.frame.size.height / 2 + self.peopleCollectionView.contentOffset.y)

        guard let indexPath = self.peopleCollectionView.indexPathForItem(at: centerPoint) else { return }
        if self.centerCell != nil && centerIndex != indexPath.item {
            self.centerCell?.transformToStandard()
        }
        if !canfromSameIndex {
            guard indexPath.item != self.centerIndex else { return }
        }
        
        self.centerIndex = indexPath.item
        self.centerCell = self.peopleCollectionView.cellForItem(at: indexPath) as? PeopleSelectCollectionViewCell
        self.centerCell?.transformToLarge()
    }
}

extension PersonSelectViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.centerCell != nil {
            self.centerCell?.transformToStandard()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        highlightCenterCell(canfromSameIndex: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        highlightCenterCell(canfromSameIndex: true)
    }
}

