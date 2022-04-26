//
//  ResultGraphTableViewCell.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/19.
//

import UIKit

struct ResultGraphElement: Hashable {
    let componentName: String
    let score: Int?
    let color: UIColor
    
    var bestImage: UIImage? {
        switch componentName {
        case "MBTI" : return UIImage(named: "imgResultTopMbti")
        case "별자리" : return UIImage(named: "imgResultTopSign")
        case "이름점" : return UIImage(named: "imgResultTopName")
        case "혈액형" : return UIImage(named: "imgResultTopBloodtype")
        default: return nil
        }
    }
}

class ResultGraphTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var bestImageView: UIImageView!
    
    private var graphElement: ResultGraphElement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }

    private func prepareUIs() {
        self.backgroundColor = .clear
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        scoreLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        progressBar.trackTintColor = .paleLilac
        progressBar.makeRounded(cornerRadius: 9)
        
        bestImageView.alpha = 0
    }
    
    private func setNilProgressBar() {
        progressBar.progress = 0.5
        progressBar.progressTintColor = .veryLightPink
        titleLabel.textColor = .textblack50
    }
    
    func setCell(graphElement: ResultGraphElement) {
        self.graphElement = graphElement
        titleLabel.textColor = graphElement.color
        titleLabel.text = graphElement.componentName
        scoreLabel.text = graphElement.score == nil ? "-" : "\(String(graphElement.score!))점"
        progressBar.progressTintColor = graphElement.color

        bestImageView.image = graphElement.bestImage

        barAnimate()
    }
    
    func barAnimate() {
        progressBar.setProgress(0, animated: false)
        bestImageView.alpha = 0
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard
                    let graphElement = self.graphElement,
                    let score = graphElement.score
                else {
                    self.setNilProgressBar()
                    return
                }
                self.progressBar.setProgress(Float(score) / 100.0, animated: true)
            }
        },completion: { [weak self] finished in
            guard let self = self else { return }
            if let graphElement = self.graphElement,
               graphElement.score == 100 || (graphElement.componentName == "혈액형" && graphElement.score == 90) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 1.0, animations: { [weak self] in
                        guard let self = self else { return }
                        self.bestImageView.alpha = 1
                    })
                }
            }
        })
    }
    
}
