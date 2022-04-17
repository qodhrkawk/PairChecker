//
//  PeopleListViewDelegate.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/14.
//

import Foundation

protocol PeopleListViewDelegate: AnyObject {
    func personTapped(person: Person)
    func personRemoved()
}
