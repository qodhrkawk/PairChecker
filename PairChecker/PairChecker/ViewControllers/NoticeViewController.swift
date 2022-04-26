//
//  NoticeViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/24.
//

import UIKit
import Combine

class NoticeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIs()
        bindButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    private func prepareUIs() {
        view.backgroundColor = .paleGrey
        scrollContainView.backgroundColor = .paleGrey
    }
    
    private func bindButton() {
        backButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &cancellables)
    }
}
