//
//  QuestionViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/24.
//

import UIKit
import Combine

class QuestionViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var copyImageView: UIImageView!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        bindButtons()
        setGestures()
    }
    
    private func prepareUIs() {
        view.backgroundColor = .mainBackground
        
        contactLabel.textColor = .paleGrey
        emailLabel.textColor = .paleGrey
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "theteamkarry@gmail.com", attributes: underlineAttribute)
        emailLabel.attributedText = underlineAttributedString
        emailLabel.sizeToFit()
    }
    
    private func bindButtons() {
        backButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &cancellables)
        
        copyButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.showToastView()
            })
            .store(in: &cancellables)
    }
    
    @objc private func showToastView() {
        UIPasteboard.general.string = "theteamkarry@gmail.com"
        showToast(text: "주소가 클립보드에 복사되었습니다.")
    }
    
    private func setGestures() {
        emailLabel.isUserInteractionEnabled = true
        copyImageView.isUserInteractionEnabled = true
        
        let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showToastView))
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showToastView))
        
        emailLabel.addGestureRecognizer(labelTapGestureRecognizer)
        copyImageView.addGestureRecognizer(imageTapGestureRecognizer)
    }

}
