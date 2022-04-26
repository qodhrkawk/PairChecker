//
//  UITextView+.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/25.
//

import UIKit

extension UITextView {
    func setTextWithLineSpacing(text: String, spacing: CGFloat, font: UIFont) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = spacing
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: font
        ]
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
