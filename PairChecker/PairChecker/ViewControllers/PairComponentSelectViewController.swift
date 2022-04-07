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
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var pairComponentTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    private var mainAnimalSubscription: AnyCancellable?
    private var pairComponentModelSubscription: AnyCancellable?
    
    private var dataSource: DataSource?
    typealias DataSource = UITableViewDiffableDataSource<PairComponentSelection, PairCheckComponentModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PairComponentSelection, PairCheckComponentModel>
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: PairCheckViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        prepareTableView()
        bindButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.bindPairComponentViewController()
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
        
    }
    
    private func bindButtons() {
        backButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
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
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension PairComponentSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
