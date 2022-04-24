//
//  CalculateAnimationView.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/23.
//

import UIKit
import Lottie

class CalculateAnimationView: UIView {

    let animationView: AnimationView = {
        let animationView = AnimationView(name: "loading")
        animationView.loopMode = .loop
        
        return animationView
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "궁합 계산중..."
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUIs()
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func prepareUIs() {
        self.backgroundColor = .black70
        
        self.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(195)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-75)
        }
        
        self.addSubview(loadingLabel)
        
        loadingLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.top.equalTo(self.animationView.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
    }

}
