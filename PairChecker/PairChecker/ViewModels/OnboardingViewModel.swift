//
//  OnboardingViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/07.
//

import Combine

class OnboardingViewModel {
    @Published var onboardingPhase: Int = 0
    
    func addPhase() {
        guard onboardingPhase < 3 else { return }
        onboardingPhase += 1
    }
}
