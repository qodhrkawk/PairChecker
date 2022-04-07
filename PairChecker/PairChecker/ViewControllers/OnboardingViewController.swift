//
//  OnboardingViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/07.
//

import UIKit
import Combine
import SnapKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var scrollContainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var definiteButton: UIButton!
    
    @IBOutlet weak var secondPhaseContainView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var flipImageView: UIImageView!
    @IBOutlet var flipImageViews: [UIImageView]!
    
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var heightConstraints: [NSLayoutConstraint]!
    @IBOutlet var ydiffContstraints: [NSLayoutConstraint]!
    
    private var cancellables = Set<AnyCancellable>()
    private var phaseSubscription: AnyCancellable?
    
    
    private var labelTexts = ["좋아, 잘 왔어!\n궁합점을 보려면\n최소한의 프로필이 필요해😎", "친구들👫, 내 아이돌🎤\n배우🎬, 만화속 주인공📺 등", "내가 좋아하는 사람들의\n프로필을 모으다 보면 👀\n메인도 더 귀여워질 거야!🌈", "그럼,\n내 프로필 먼저 등록해볼까?"]
    
    private var viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        adjustConstraints()
        bindButtons()
        bindViewModel()
        addContainViewGesture()
    }
    
    private func prepareUIs() {
        view.backgroundColor = .paleGrey
        scrollContainView.backgroundColor = .paleGrey
        
        definiteButton.setTitle("완전!", for: .normal)
        startButton.setTitle("시작하기", for: .normal)
        
        for button in buttons {
            button.makeRounded(cornerRadius: 14)
            button.backgroundColor = .animalSkyblue
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        }
        
        for (index, label) in labels.enumerated() {
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 26, weight: .bold)
            label.textColor = .white
            
            let attributedString = NSMutableAttributedString(string:  labelTexts[index])
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            label.attributedText = attributedString
        }
        
        secondPhaseContainView.backgroundColor = .mainBackground
    }
    
    private func adjustConstraints() {
        for heightConstraint in heightConstraints {
            heightConstraint.constant *= DeviceInfo.screenHeightRatio
        }
        
        for ydiffContstraint in ydiffContstraints {
            ydiffContstraint.constant *= DeviceInfo.screenHeightRatio
        }
    }
    
    private func bindButtons() {
        definiteButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 812 * DeviceInfo.screenHeightRatio), animated: false)
                }, completion: nil)
            })
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        phaseSubscription = viewModel.$onboardingPhase
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] phase in
                self?.adaptPhase(phase: phase)
            })
    }
    
    private func adaptPhase(phase: Int) {

        for (index, label) in labels.enumerated() {
            if index == phase {
                UIView.animate(withDuration: 0.5, animations: {
                    label.alpha = 1
                })
                view.addSubview(flipImageViews[index])
                flipImageViews[index].snp.remakeConstraints { make in
                    make.width.height.equalTo(24)
                    make.leading.equalTo(label.snp.trailing).offset(6)
                    make.bottom.equalTo(label.snp.bottom).offset(-4)
                }
                startFlip(index: index)
            }
            else if index == phase - 1 {
                UIView.animate(withDuration: 0.5, animations: {
                    label.alpha = 0.05
                })
                flipImageViews[index].removeFromSuperview()
            }
            else {
                label.alpha = 0.05
                flipImageViews[index].removeFromSuperview()
            }
        }
        if phase == 3 {
            startButton.backgroundColor = .animalSkyblue
            startButton.setTitleColor(.black, for: .normal)
            startButton.isEnabled = true
        }
        else {
            startButton.backgroundColor = .darkGray
            startButton.setTitleColor(.white10, for: .normal)
            startButton.isEnabled = false
        }
    }
    
    private func startFlip(index: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            if self.flipImageViews[index].alpha == 0 {
                self.flipImageViews[index].alpha = 1
            }
            else {
                self.flipImageViews[index].alpha = 0
            }
        },completion: { [weak self] _ in
//            guard let self = self
            self?.startFlip(index: index)
        })
    }
    
    private func addContainViewGesture() {
        secondPhaseContainView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondContainViewTapped))
        secondPhaseContainView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func secondContainViewTapped() {
        viewModel.addPhase()
    }

}
