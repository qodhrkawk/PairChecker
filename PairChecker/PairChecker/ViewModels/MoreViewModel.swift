//
//  MoreViewModel.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/24.
//

import Foundation
import Combine
import UIKit


struct MoreViewItem: Hashable {
    let viewName: String
    let viewControllerName: String
}


class MoreViewModel {
    @Published var moreViewItems: [MoreViewItem] = []
    
    private var viewControllerItems: [UIViewController] = []
    
    init() {
        publishMoreViewItems()
    }
    
    private func publishMoreViewItems() {
        moreViewItems = [
            MoreViewItem(viewName: "앱 소개", viewControllerName: "AppIntroduceViewController"),
            MoreViewItem(viewName: "개발자 정보 및 문의", viewControllerName: "QuestionViewController"),
            MoreViewItem(viewName: "개인정보 수집 및 관리 안내", viewControllerName: "NoticeViewController")
        ]
        
        let viewControllerClasses = [AppIntroduceViewController.self, QuestionViewController.self, NoticeViewController.self]
        
        for index in 0..<viewControllerClasses.count {
            guard let viewController = viewControllerClasses[index].instantiateFromStoryboard(StoryboardName.more)
            else { continue }
            
            viewControllerItems.append(viewController)
        }
    }
    
    func getViewController(of name: String) -> UIViewController? {
        for viewController in viewControllerItems {
            if String(describing: viewController).contains(name) {
                return viewController
            }
        }
        return nil
    }
    
}
