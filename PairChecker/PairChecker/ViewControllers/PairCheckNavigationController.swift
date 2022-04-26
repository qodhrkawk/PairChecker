//
//  PairCheckNavigationController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/04.
//

import UIKit

class PairCheckNavigationController: UINavigationController {
    var viewModel = PairCheckViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(navigationControllerShouldDismiss), name: .pairCheckNavigationControllerShouldDismiss, object: nil)
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc func navigationControllerShouldDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
