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
let dashboardSetStrokeWidth: CGFloat = 0.5
let dashboardStrokeWidth: CGFloat = 1.5
let chartLineWidth: CGFloat = 2

func getNavigationBarHeight(viewController: UIViewController) -> CGFloat {
    var navigationBarHeight: CGFloat?
    if let navController = viewController.navigationController {
        navigationBarHeight = navController.navigationBar.frame.height
    } else if let navController = viewController as? UINavigationController {
        navigationBarHeight = navController.navigationBar.frame.height
    }
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
