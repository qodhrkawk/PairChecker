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
    
    func showPopupView(
        alerTitle: String,
        alertMessage: String,
        leftTitle: String,
        rightTitle: String,
        leftActionHandler: @escaping () -> Void,
        rightActionHandler: @escaping () -> Void
    ) {
        let alertController = UIAlertController(title: alerTitle, message: alertMessage, preferredStyle: .alert)
        let leftAction = UIAlertAction(title: leftTitle, style: .default, handler: { action in
            leftActionHandler()
        })
        
        let rightAction = UIAlertAction(title: rightTitle, style: .default, handler: { action in
            rightActionHandler()
        })
        
        alertController.addAction(leftAction)
        alertController.addAction(rightAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
        
    func showPersonDeletePopup(person: Person, deleteCompletion: @escaping () -> Void) {
        let deleteAlert = UIAlertController(title: "이 프로필을 삭제할까?", message: "한번 삭제한 프로필은 되돌릴 수 없어!", preferredStyle: .alert)
        let deleteAlertDeleteAction = UIAlertAction(title: "삭제", style: .default, handler: { action in
            UserManager.shared.deletePerson(person: person)
            deleteCompletion()
        })
        let deleteAlertCancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        deleteAlert.addAction(deleteAlertDeleteAction)
        deleteAlert.addAction(deleteAlertCancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
}
