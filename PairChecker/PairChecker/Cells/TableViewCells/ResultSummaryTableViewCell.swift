//
//  ResultSummaryTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/17.
//

import UIKit
import Combine

class ResultSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var animalImageViews: [UIImageView]!
    
    @IBOutlet var nameViews: [UIView]!
    @IBOutlet var nameLabels: [UILabel]!
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var highlightImageView: UIImageView!
    
    @IBOutlet var resultScoreLabels: [UILabel]!
    @IBOutlet var resultTitleLabels: [UILabel]!
    
    @IBOutlet weak var resultExplainLabel: UILabel!
    
    @IBOutlet weak var resultSummaryContainView: UIView!
    @IBOutlet weak var resultBackgroundImageView: UIImageView!
    @IBOutlet weak var resultStarImageView: UIImageView!
    @IBOutlet weak var resultArrowImageView: UIImageView!
    @IBOutlet weak var resultCommentImageVIew: UIImageView!
    
    weak var delegate: ResultViewDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var peopleSubscription: AnyCancellable?
    private var resultSubscription: AnyCancellable?
    private var averageScoreSubscription: AnyCancellable?
    private var resultTextSubscription: AnyCancellable?
        
    var viewModel: PairCheckViewModel? {
        didSet {
            self.bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
        bindViewModel()
        bindButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func prepareUIs() {
        self.backgroundColor = .charcoalGrey
        
        titleLabel.text = "결과는...😎"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
        
        highlightImageView.image = UIImage(named: "imgResultLine")?.withRenderingMode(.alwaysTemplate)
        resultStarImageView.image = UIImage(named: "imgResultStars")?.withRenderingMode(.alwaysTemplate)
        resultArrowImageView.image = UIImage(named: "imgResultArrow")?.withRenderingMode(.alwaysTemplate)
        resultCommentImageVIew.image = UIImage(named: "imgResultComent")?.withRenderingMode(.alwaysTemplate)
        
        
        for nameView in nameViews {
            nameView.backgroundColor = .clear
        }
        
        nameViews.last?.transform = CGAffineTransform(rotationAngle:  -3.14 / 14)
        
        for nameLabel in nameLabels {
            nameLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        }
        
        totalScoreLabel.font = UIFont(name: "GmarketSansBold", size: 50)
        
        for resultScoreLabel in resultScoreLabels {
            resultScoreLabel.font = UIFont(name: "GmarketSansBold", size: 20)
        }
        
        for (index, resultTitleLabel) in resultTitleLabels.enumerated() {
            resultTitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
            resultTitleLabel.textColor = .blueGrey
            
            switch index {
            case 0: resultTitleLabel.text = "이름점"
            case 1: resultTitleLabel.text = "별자리"
            case 2: resultTitleLabel.text = "MBTI"
            case 3: resultTitleLabel.text = "혈액형"
            default:
                break
            }
        }
        
        resultSummaryContainView.backgroundColor = .clear
        resultExplainLabel.text = "유사과학까지 인정해버린 둘!\n이정도면 베스트 찰떡궁합!"
        resultExplainLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        peopleSubscription = viewModel.$selectedPeople
            .sink(receiveValue: { [weak self] people in
                print(people)
                print(people.count)
                guard let self = self,
                      people.count == 2
                else { return }
                
                for (index, person) in people.enumerated() {
                    self.nameLabels[index].text = person.name
                    self.animalImageViews[index].image = person.animal.stickerImage
                    
                }
                self.resultStarImageView.tintColor = people[0].animal.themeColor.uicolor
                self.resultArrowImageView.tintColor = people[1].animal.themeColor.uicolor
                self.highlightImageView.tintColor = people[0].animal.themeColor.uicolor
                self.resultCommentImageVIew.tintColor = people[0].animal.themeColor.uicolor
            })
        
        resultSubscription = viewModel.$pairCheckResult
            .sink(receiveValue: { [weak self] results in
                guard let self = self,
                      results.count == 4
                else { return }
                
                for (index, result) in results.enumerated() {
                    if let unwrappedResult = result {
                        self.resultScoreLabels[index].text = String(unwrappedResult)
                    }
                    else {
                        self.resultScoreLabels[index].text = "-"
                    }
                }
                
                let averageScore = results.compactMap { $0 }.reduce(0) { $0 + $1 } / results.compactMap { $0 }.count
                self.totalScoreLabel.text = String(averageScore)
            })
        
        averageScoreSubscription = viewModel.$averageScore
            .sink(receiveValue: { [weak self] score in
                self?.totalScoreLabel.text = String(score)
            })
        
        resultTextSubscription = viewModel.$resultText
            .sink(receiveValue: { [weak self] text in
                self?.resultExplainLabel.text = text
            })
    }
    
    private func bindButton() {
        xButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] in
                self?.delegate?.dismissView()
            })
            .store(in: &cancellables)
    }
    
    func startAnimation() {
        resultSummaryContainView.transform = CGAffineTransform(translationX: 0, y: DeviceInfo.screenHeight * 0.6)
        UIView.animate(withDuration: 0.5, delay: 0, animations: { [weak self] in
            self?.resultSummaryContainView.transform = .identity
        })
        
    }
}
