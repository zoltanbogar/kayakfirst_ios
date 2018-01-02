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
let dashboardDividerWidth: CGFloat = 0.5
let chartLineWidth: CGFloat = 2
let trainingRowHeight: CGFloat = 56
let profileElementHeight: CGFloat = 50
let planElementHeight: CGFloat = 40
let timeLineHeight: CGFloat = 10
let planRadius: CGFloat = 9
let dashboardPauseSwipeArea: CGFloat = 180
let colorNormalDialogElement = Colors.colorWhite
let colorHighlitedDialogElement = Colors.colorAccent

//text
let planElementCellTextSize: CGFloat = 18

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

func isScreenPortrait(size: CGSize) -> Bool {
    if (size.width / size.height > 1) {
        return false
    } else {
        return true
    }
}
