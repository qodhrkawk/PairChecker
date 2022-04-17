//
//  FloatButtonView.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/11.
//

import UIKit
import SnapKit

class FloatButtonView: UIView {
    
    let buttons: [UIButton] = {
        var buttons: [UIButton] = []
        for _ in 0..<2 {
            buttons.append(UIButton())
        }
        return buttons
    }()
    
    let titleLabels: [UILabel] = {
        var labels: [UILabel] = []
        for _ in 0..<2 {
            labels.append(UILabel())
        }
        return labels
    }()
    
    let titleImageViews: [UIImageView] = {
        var imageViews: [UIImageView] = []
        for _ in 0..<2 {
            imageViews.append(UIImageView())
        }
        return imageViews
    }()
    
    let borderView: UIView = {
        var view = UIView()
        view.backgroundColor = .charcoalGrey36
        return view
    }()
    
    var editClosure: (() -> Void)?
    var removeClosure: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func prepareUIs() {
        self.backgroundColor = .white
        self.makeRounded(cornerRadius: 15)
        self.dropShadow(color: .black, offSet: CGSize(width: 0, height: 3), opacity: 0.3, radius: 30)
        
        self.addSubview(buttons[0])
        self.addSubview(buttons[1])
        
        self.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        
        buttons[0].snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(49)
        }
        
        buttons[1].snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(49)
        }
        
        buttons[0].addSubview(titleLabels[0])
        titleLabels[0].text = "프로필 수정"
        titleLabels[0].font = .systemFont(ofSize: 17)
        titleLabels[0].textColor = .black
        titleLabels[0].snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        buttons[1].addSubview(titleLabels[1])
        titleLabels[1].text = "프로필 삭제"
        titleLabels[1].font = .systemFont(ofSize: 17)
        titleLabels[1].textColor = .orangeyRed
        titleLabels[1].snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        buttons[0].addSubview(titleImageViews[0])
        titleImageViews[0].image = UIImage(named: "icPopupEdit")
        titleImageViews[0].snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-9)
        }
        
        buttons[1].addSubview(titleImageViews[1])
        titleImageViews[1].image = UIImage(named: "icPopupRemove")
        titleImageViews[1].snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-9)
        }
        
        buttons[0].addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        buttons[1].addTarget(self, action: #selector(removeButtonAction), for: .touchUpInside)
    }

    @objc func editButtonAction() {
        editClosure?()
    }
    
    @objc func removeButtonAction() {
        removeClosure?()
    }
}
