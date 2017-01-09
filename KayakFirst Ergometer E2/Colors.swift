//
//  Colors.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import UIKit

enum Colors: String {
    case colorPrimary = "#383e42"
    case colorPrimaryDark = "#000000"
    case colorAccent = "#e25303"
    case colorAccentDark = "#cb4a02"
    case colorWhite = "#f2f2f2"
    case colorWhiteDark = "#d9d9d9"
    case colorInactive = "#4d4d4d"
    case dragDropStart = "#ffe25303"
    case dragDropEnter = "#bbe25303"
    case startDelayBackground = "#eedf5626"
    //case colorDashboardDivider = "#4d4d4d"
    case colorBluetooth = "#2196F3"
    case colorTransparent = "#00000000"
    case colorT = "#FFFF00"
    case colorStrokes = "#cd2929"
    case colorF = "#0dd278"
    case colorV = "#005cff"
}

func getColor(_ colorsEnum: Colors) -> UIColor {
    return getColor(colorsEnum.rawValue)
}

func getColor(_ hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }
    
    var rgbValue: UInt32 = 0
    
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    let length = cString.characters.count
    
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
    var alpha: CGFloat = 1.0
    
    if length == 8 {
        alpha = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
    } else if length != 6 {
        return UIColor.black
    }
    return UIColor(
        red: red,
        green: green,
        blue: blue,
        alpha: alpha
    )
}
