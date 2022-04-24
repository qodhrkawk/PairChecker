//
//  PersonSelectEmtpyView.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/23.
//

import UIKit
import SnapKit
import Combine

class PersonSelectEmtpyView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 없음!"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "궁합 볼 상대의 프로필 등록이 필요해!"
        label.textColor = .white20
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("새 프로필 추가", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .charcoalGrey
        button.makeRounded(cornerRadius: 14)
        
        return button
    }()
    
    private var buttonActionClosure: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func prepareUIs() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(33)
        }
        
        self.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(46)
            make.top.equalToSuperview().offset(82)
        }
        
        addButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.buttonActionClosure?()
            })
            .store(in: &cancellables)
    }
    
    func setButtonAction(buttonAction: @escaping () -> Void) {
        buttonActionClosure = buttonAction
    }
}
