//
//  PairComponentSelectViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/04.
//

import UIKit
import Combine

enum PairComponentSelection: Hashable {
    case main
}

class PairComponentSelectViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var pairComponentTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    private var mainAnimalSubscription: AnyCancellable?
    private var pairComponentModelSubscription: AnyCancellable?
    private var pairComponentSelectedSubscription: AnyCancellable?
    private var checkButtonImageSubscription: AnyCancellable?
    
    private var dataSource: DataSource?
    typealias DataSource = UITableViewDiffableDataSource<PairComponentSelection, PairCheckComponentModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PairComponentSelection, PairCheckComponentModel>
    
    private var cancellables = Set<AnyCancellable>()
    
    let animationView = CalculateAnimationView()
    var animationTimer: Timer?
    
    var viewModel: PairCheckViewModel? {
        didSet {
//            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        prepareTableView()
        bindButtons()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        bindViewModel()
//        viewModel?.bindPairComponentViewController()
    }

    func prepareUIs() {
        view.backgroundColor = .mainBackground
        
        titleLabel.text = "어떤 (유사)과학의\n힘을 빌려볼까?🤓"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        
        subTitleLabel.text = "유사과학도 아무튼 과학임!"
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .white
        subTitleLabel.alpha = 0.4
        
        selectButton.makeRounded(cornerRadius: 14)
        selectButton.setTitle("선택완료", for: .normal)
        selectButton.setTitleColor(.black, for: .normal)
        selectButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        selectButton.backgroundColor = .animalGreen
    }
    
    func prepareTableView() {
        pairComponentTableView.backgroundColor = .mainBackground
        pairComponentTableView.registerCell(cell: PairComponentTableViewCell.self)
        pairComponentTableView.delegate = self
        
        setupDataSource()
    }
    
    private func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        viewModel.bindPairComponentViewController()
        
        mainAnimalSubscription = viewModel.$mainAnimal
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] animal in
                self?.selectButton.backgroundColor = animal?.themeColor.uicolor ?? .animalGreen
            })
        
        pairComponentModelSubscription = viewModel.$pairCheckComponentModelsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] models in
                self?.updateComponentModels(pairCheckComponentModels: models)
            })
        
        pairComponentSelectedSubscription = viewModel.$pairCheckComponentSelected
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] selected in
                guard let self = self else { return }
                if selected {
                    self.selectButton.backgroundColor = .animalGreen
                    self.selectButton.setTitleColor(.black, for: .normal)
                    self.selectButton.isEnabled = true
                }
                else {
                    self.selectButton.backgroundColor = .darkGrey
                    self.selectButton.setTitleColor(.white10, for: .normal)
                    self.selectButton.isEnabled = false
                }
            })
        
        checkButtonImageSubscription = viewModel.$selectedIconImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.checkImageView.image = image
            })
    }
    
    private func bindButtons() {
        backButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &cancellables)
        
        checkButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.viewModel?.selectAllComponents()
                for index in 0..<PairCheckComponent.allCases.count {
                    guard let cell = self.pairComponentTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PairComponentTableViewCell
                    else { continue }
                    cell.componentModel?.selected = true
                    cell.adaptToSelection()
                }
                
            })
            .store(in: &cancellables)
        
        selectButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.view.addSubview(self.animationView)
                
                self.animationView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                self.animationTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { [weak self] timer in
                    guard let self = self,
                          let resultViewController = ResultViewController.instantiateFromStoryboard(StoryboardName.result)
                    else { return }
                    resultViewController.modalPresentationStyle = .fullScreen
                    resultViewController.viewModel = self.viewModel
                    self.viewModel?.moveToResultView()
                    self.navigationController?.present(resultViewController, animated: false, completion: nil)
                })
            })
            .store(in: &cancellables)
    }
    
    
    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: pairComponentTableView, cellProvider: { (tableView, indexPath, componentModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PairComponentTableViewCell", for: indexPath) as! PairComponentTableViewCell
            cell.componentModel = componentModel
            cell.delegate = self.viewModel
            return cell
        })
    }
    
    private func updateComponentModels(pairCheckComponentModels: [PairCheckComponentModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(pairCheckComponentModels, toSection: .main)
        
        guard let dataSource = self.dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension PairComponentSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
