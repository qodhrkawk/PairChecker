//
//  UIView+.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/05.
//

import UIKit

extension UIView {
    static var isExistNibFile: Bool {
        let nibName = String(describing: self)
        return Bundle.main.path(forResource: nibName, ofType: "nib") != nil
    }
    
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
}
