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
    
    var viewModel = PeopleSelectViewModel()
    
    private var centerCell: PeopleSelectCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        prepareCollectionView()
        bindViewModel()
        bindButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        highlightCenterCell()
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
        
        selectionImage.image = UIImage(named: "imgSelectedProfile")?.withRenderingMode(.alwaysTemplate)
    }
    
    private func bindViewModel() {
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
                self?.dismiss(animated: true, completion: nil)
            })
            .store(in: &cancellables)
        
        
    }
    
    private func prepareCollectionView() {
        peopleCollectionView.backgroundColor = .mainBackground
        peopleCollectionView.registerCell(cell: PeopleSelectCollectionViewCell.self)
        
        peopleCollectionView.decelerationRate = .fast
        peopleCollectionView.delegate = self
        
        let flowLayout = PeopleSelectionCollectionViewFlowLayout()
        flowLayout.delegate = self
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
    
    private func highlightCenterCell() {
        let centerPoint = CGPoint(x: self.peopleCollectionView.frame.size.width / 2 + self.peopleCollectionView.contentOffset.x,
                                  y: self.peopleCollectionView.frame.size.height / 2 + self.peopleCollectionView.contentOffset.y)

        guard let indexPath = self.peopleCollectionView.indexPathForItem(at: centerPoint) else { return }
        if self.centerCell != nil {
            self.centerCell?.transformToStandard()
        }
        self.centerCell = self.peopleCollectionView.cellForItem(at: indexPath) as? PeopleSelectCollectionViewCell
        self.centerCell?.transformToLarge()
    }
}

extension PersonSelectViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView == peopleCollectionView {
//            let layout = peopleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//            var offset = targetContentOffset.pointee
//            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
//            var roundedIndex = round(index)
//
//            if scrollView.contentOffset.x > targetContentOffset.pointee.x {
//                roundedIndex = floor(index)
//            } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
//                roundedIndex = ceil(index)
//            }
//            if currentIndex > roundedIndex {
//                currentIndex -= 1
//                roundedIndex = currentIndex
//            } else if currentIndex < roundedIndex {
//                currentIndex += 1
//                roundedIndex = currentIndex
//            }
////            viewModel.updateCurrentIndex(index: Int(currentIndex))
//
//            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//            targetContentOffset.pointee = offset
//        }
    }
    
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let centerPoint = CGPoint(x: peopleCollectionView.frame.size.width / 2 + scrollView.contentOffset.x,
//                                  y: peopleCollectionView.frame.size.height / 2 + scrollView.contentOffset.y)
//
//        if let indexPath = peopleCollectionView.indexPathForItem(at: centerPoint), self.centerCell == nil {
//            self.centerCell = peopleCollectionView.cellForItem(at: indexPath) as? PeopleSelectCollectionViewCell
//            self.centerCell?.transformToLarge()
////            self.peopleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//
//        guard let centerCell = self.centerCell else { return }
//
//        let offsetX = centerPoint.x - centerCell.center.x
//
//        if offsetX < -36 || offsetX > 36 {
//            centerCell.transformToStandard()
//            self.centerCell = nil
//        }
//
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.centerCell != nil {
            self.centerCell?.transformToStandard()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        highlightCenterCell()
    }
}


extension PersonSelectViewController: PeopleSelectionCollectionViewLayoutDelegate {
    func offsetAdjusted() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100), execute: { [weak self] in
//            guard let self = self else { return }
//            let centerPoint = CGPoint(x: self.peopleCollectionView.frame.size.width / 2 + self.peopleCollectionView.contentOffset.x,
//                                      y: self.peopleCollectionView.frame.size.height / 2 + self.peopleCollectionView.contentOffset.y)
//            print("clll")
//            guard let indexPath = self.peopleCollectionView.indexPathForItem(at: centerPoint) else { return }
//            if self.centerCell != nil {
//                self.centerCell?.transformToStandard()
//            }
//            self.centerCell = self.peopleCollectionView.cellForItem(at: indexPath) as? PeopleSelectCollectionViewCell
//            self.centerCell?.transformToLarge()
//        })
       
    }
}
