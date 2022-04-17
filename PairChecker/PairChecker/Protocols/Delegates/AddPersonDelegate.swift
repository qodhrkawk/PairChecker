//
//  AddPersonDelegate.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/14.
//

import Foundation

protocol AddPersonDelegate: AnyObject {
    func personRegistered(person: Person)
}
