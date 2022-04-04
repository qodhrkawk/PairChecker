//
//  BackCardView.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/01.
//

import UIKit
import SnapKit

class BackCardView: UIView {
    
    let titleLabels: [UILabel] = {
        var labels: [UILabel] = []
        for _ in 0..<5 {
            labels.append(UILabel())
        }
        return labels
    }()
    let infoLabels: [UILabel] = {
        var labels: [UILabel] = []
        for _ in 0..<5 {
            labels.append(UILabel())
        }
        return labels
    }()
    let lineViews: [UIView] = {
        var views: [UIView] = []
        for _ in 0..<4 {
            views.append(UIView())
        }
        return views
    }()
    
    var person: Person? {
        didSet {
            guard let person = person else { return }

            for (index, infoLabel) in infoLabels.enumerated() {
                switch index {
                case 0: infoLabel.text = person.name
                case 1: infoLabel.text = person.birthDate
                case 2: infoLabel.text = person.sign?.koreanName ?? "-"
                case 3: infoLabel.text = person.bloodType?.koreanName ?? "-"
                default:
                    guard let mbti = person.mbti else {
                        infoLabel.text = "-"
                        return
                    }
                    infoLabel.text = "\(mbti)"
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func prepareUIs() {
        backgroundColor = .white
        
        for (index, titleLabel) in titleLabels.enumerated() {
            self.addSubview(titleLabel)
            titleLabel.textColor = .textblack
            titleLabel.font = .systemFont(ofSize: 14)
            titleLabel.alpha = 0.4
            switch index {
            case 0:
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(6)
                }
                titleLabel.text = "이름"
            case 1:
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(68)
                }
                titleLabel.text = "생년월일"
            case 2:
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(130)
                }
                titleLabel.text = "별자리"
            case 3:
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(192)
                }
                titleLabel.text = "혈액형"
            default:
                titleLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(81)
                    make.top.equalToSuperview().offset(192)
                }
                titleLabel.text = "MBTI"
            }
            
        }
        
        for (index, infoLabel) in infoLabels.enumerated() {
            infoLabel.font = .systemFont(ofSize: 20, weight: .bold)
            self.addSubview(infoLabel)
            switch index {
            case 0:
                infoLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(27)
                }
            case 1:
                infoLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(89)
                }
            case 2:
                infoLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(151)
                }
            case 3:
                infoLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.top.equalToSuperview().offset(213)
                }
            default:
                infoLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(81)
                    make.top.equalToSuperview().offset(213)
                }
            }
        }
        
        for (index, lineView) in lineViews.enumerated() {
            lineView.backgroundColor = .black20
            self.addSubview(lineView)
            switch index {
            case 0:
                lineView.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.trailing.equalToSuperview().offset(-24)
                    make.top.equalToSuperview().offset(56)
                    make.height.equalTo(1)
                }
            case 1:
                lineView.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.trailing.equalToSuperview().offset(-24)
                    make.top.equalToSuperview().offset(118)
                    make.height.equalTo(1)
                }
            case 2:
                lineView.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.trailing.equalToSuperview().offset(-24)
                    make.top.equalToSuperview().offset(180)
                    make.height.equalTo(1)
                }
            default:
                lineView.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(24)
                    make.trailing.equalToSuperview().offset(-24)
                    make.top.equalToSuperview().offset(242)
                    make.height.equalTo(1)
                }
            }
        }
        
        
    }
}
