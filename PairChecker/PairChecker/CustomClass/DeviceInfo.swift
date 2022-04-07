//
//  DeviceInfo.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/04/07.
//

import UIKit

struct DeviceInfo {
    static var screenWidth: CGFloat     { return UIScreen.main.bounds.width }
    static var screenHeight: CGFloat    { return UIScreen.main.bounds.height }
   
    static var screenHeightRatio: CGFloat { return DeviceInfo.screenHeight / 812.0 }
    
}
