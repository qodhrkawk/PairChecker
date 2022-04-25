//
//  AppIntroduceViewController.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/24.
//

import UIKit
import Combine

class AppIntroduceViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var introduceTextView: UITextView!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIs()
        bindButton()
        // Do any additional setup after loading the view.
    }
    
    private func updateUIs() {
        view.backgroundColor = .mainBackground

        introduceTextView.backgroundColor = .clear
        
        let text = """
        그 시절, 노트 한장 부욱 찢어서
        짝사랑하던 친구의 이름을 적어 놓고
        남몰래 궁합을 계산해 보던 일!

        유사과학은 말 그대로
        허무맹랑한 미신일 뿐이지만,
        그덕에 즐거웠던 건
        진짜로 존재하는 우리들의 추억이야.

        ‘궁합노트'는 그 시절 노트 위의 설렘을
        다시 나누고 싶어서 생기게 됐어.
        내가 좋아하는 모든 사람과
        즐거운 기억을 만들어 보자!
        """
        introduceTextView.setTextWithLineSpacing(text: text, spacing: 13, font: .systemFont(ofSize: 18, weight: .bold))
    }
    
    private func bindButton() {
        backButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &cancellables)
    }

    
    
}
