//
//  DashBoardElementTime.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 11..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashBoardelementTime: DashBoardElement {
    
    private let dateFormatHelper = DateFormatHelper()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dateFormatHelper.format = getStringFormatter()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateFormatHelper.format = getStringFormatter()
    }
    
    override func getFormattedText() -> String {
        return dateFormatHelper.getTime(millisec: getValue())!
    }
    
}
