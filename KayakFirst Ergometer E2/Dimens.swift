//
//  Dimens.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

let margin05: CGFloat = 10.0
let margin: CGFloat = 20.0
let margin1_5: CGFloat = 30
let margin2: CGFloat = 40.0
let buttonHeight: CGFloat = 40.0
let dashboardRadius: CGFloat = 7
let dashboardSetStrokeWidth: CGFloat = 1

func getNavigationBarHeight(viewController: UIViewController) -> CGFloat {
    let navigationBarHeight = viewController.navigationController?.navigationBar.frame.height
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var height: CGFloat = statusBarHeight
    
    if let navHeight = navigationBarHeight {
        height = height + navHeight
    }
    
    return height
}

func getTabBarHeight(viewController: UIViewController) -> CGFloat {
    let tabBarHeight = viewController.tabBarController?.tabBar.frame.size.height
    return tabBarHeight == nil ? 0 : tabBarHeight!
}
