//
//  UIViewController+.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
    }
    
    static func instantiateFromStoryboard(_ name: String = "Main") -> Self? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: self)
        
        return storyboard.instantiateViewController(withIdentifier: identifier) as? Self
    }
    
    static func getVisibleController(_ viewController: UIViewController? = UIViewController.rootViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return getVisibleController(navigationController.visibleViewController)
        } else if let tabbarController = viewController as? UITabBarController {
            return getVisibleController(tabbarController.selectedViewController)
        } else if let presentedController = viewController?.presentedViewController {
            return getVisibleController(presentedController)
        } else {
            return viewController
        }
    }
}
