//
//  Colors.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import UIKit

//TODO: it could be struct
class Colors {
    static let colorPrimary = getColor("#383e42")
    static let colorPrimaryTransparent = getColor("#aa383e42")
    static let colorPrimaryDark = getColor("#000000")
    static let colorAccent = getColor("#e25303")
    static let colorAccentDark = getColor("#cb4a02")
    static let colorWhite = getColor("#f2f2f2")
    static let colorWhiteDark = getColor("#d9d9d9")
    static let colorInactive = getColor("#4d4d4d")
    static let dragDropStart = getColor("#77e25303")
    static let dragDropEnter = getColor("#bbe25303")
    static let startDelayBackground = getColor("#eedf5626")
    static let colorDashBoardDivider = getColor("#4d4d4d")
    static let colorBluetooth = getColor("#2196F3")
    static let colorTransparent = getColor("#00000000")
    static let colorT = getColor("#FFFF00")
    static let colorStrokes = getColor("#cd2929")
    static let colorF = getColor("#0dd278")
    static let colorV = getColor("#005cff")
    static let colorGreen = getColor("#00b000")
    static let colorYellow = getColor("#c4b53c")
    static let colorRed = getColor("#cc0000")
    static let colorFacebook = getColor("#3b5998")
    static let colorGoogle = getColor("#dc4e41")
    static let colorQuickStart = getColor("#929292")
    static let colorProfileElement = getColor("#404447")
    static let colorSun = getColor("#ffed00")
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
