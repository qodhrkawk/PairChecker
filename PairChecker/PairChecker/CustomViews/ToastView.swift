//
//  ToastView.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/25.
//

import UIKit

class ToastView: UIView {
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var toastLabel: UILabel!

    var duration: TimeInterval = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUIs()
    }
    
    private func prepareUIs() {
        self.makeRounded(cornerRadius: 16)
        backgroundView.dropShadow(color: .black20, offSet: CGSize(width: 16, height: 16), opacity: 20, radius: 16)
        toastLabel.textColor = .newBlue
        toastLabel.font = .systemFont(ofSize: 15)
        self.backgroundColor = .mainBackground
        backgroundView.backgroundColor = .black30
    }
    
    func setTitle(text: String) {
        toastLabel.text = text
    }
    
    func show() {
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.alpha = 1
        }, completion: { [weak self] _ in
            guard let self = self else  { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) { [weak self] in
                self?.hide()
            }
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { [weak self] isFinished in
            self?.removeFromSuperview()
        })
    }

}
