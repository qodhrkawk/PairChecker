//
//  SceneDelegate.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/02/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let winScene = (scene as? UIWindowScene)
        else { return }
        decideRootViewController(window: UIWindow(windowScene: winScene))
//        window?.makeKeyAndVisible()
//        decideRootViewController()
    }

    func decideRootViewController(window: UIWindow) {
        
        guard let mainVC = MainViewController.instantiateFromStoryboard(StoryboardName.main) else { return }
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
//        if UserManager.shared.shouldShowOnboarding == nil {
//            UserManager.shared.shouldShowOnboarding = true
//        }
//
//        if let shouldShowOnboarding = UserManager.shared.shouldShowOnboarding,
//           shouldShowOnboarding == true {
//            guard let onboardingVC = OnboardingViewController.instantiateFromStoryboard(StoryboardName.onboarding)
//            else { return }
//            onboardingVC.modalPresentationStyle = .fullScreen
//            navigationController.present(onboardingVC, animated: false, completion: nil)
//        }
        
//        if PolarisUserManager.shared.hasToken == true {
//            guard let mainVC = MainVC.instantiateFromStoryboard(StoryboardName.main) else { return }
//            let navigationController = UINavigationController(rootViewController: mainVC)
//            navigationController.setNavigationBarHidden(true, animated: false)
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
//        } else {
//            guard let loginVC = LoginVC.instantiateFromStoryboard(StoryboardName.intro) else { return }
//            self.window?.rootViewController = loginVC
//            self.window?.makeKeyAndVisible()
//
//            if PolarisUserManager.shared.isInitialMember == nil {
//                guard let onboardingVC = OnboardingVC.instantiateFromStoryboard(StoryboardName.intro) else { return }
//                onboardingVC.modalPresentationStyle = .fullScreen
//                onboardingVC.modalTransitionStyle   = .crossDissolve
//                loginVC.present(onboardingVC, animated: false, completion: nil)
//            }
//        }
    }

}

