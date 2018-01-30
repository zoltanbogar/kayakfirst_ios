//
//  AppLinkHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 30..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import ActiveLabel

struct LinkHelper {
    let clickListener: (() ->())?
    let text: String
    let color: UIColor
}

class AppLinkHelper {
    
    class func linkText(activeLabel: ActiveLabel, linkHelpers: [LinkHelper]) {
        var customTypes = [ActiveType]()
        var text: String = ""
        for linkHelper in linkHelpers {
            let customType = ActiveType.custom(pattern: "\\s\(linkHelper.text)\\b")
            
            customTypes.append(customType)
            activeLabel.customColor[customType] = linkHelper.color
            
            text += linkHelper.text
            
            activeLabel.handleCustomTap(for: customType) { element in
                if let clickListener = linkHelper.clickListener {
                    clickListener()
                }
            }
        }
        
        activeLabel.enabledTypes = customTypes
        activeLabel.text = text
    }
    
}
