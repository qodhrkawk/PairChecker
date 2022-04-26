//
//  MoreNavigationController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/25.
//

import UIKit

class MoreNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
}
