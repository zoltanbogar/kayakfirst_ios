//
//  WindowHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 19..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class WindowHelper {
    
    class func setBrightness(isFull: Bool) {
        UIScreen.main.brightness = isFull ? CGFloat(1) : CGFloat(0)
    }
    
    class func keepScreenOn(isOn: Bool) {
        UIApplication.shared.isIdleTimerDisabled = isOn
    }
}
