//
//  UITableView+.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        let identifier = String(describing: cell)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    }
    
    func registerCell<T: UITableViewCell>(cell: T.Type) {
        let identifier  = String(describing: cell)
        let nib         = UINib(nibName: identifier, bundle: nil)
        
        if cell.isExistNibFile  { self.register(nib, forCellReuseIdentifier: identifier) }
        else                    { self.register(cell, forCellReuseIdentifier: identifier) }
    }
}
