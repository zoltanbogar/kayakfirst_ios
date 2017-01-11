//
//  DashBoardElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class DashBoardElement: CustomUi {
    
    override func initUi() -> UIView {
        let view = UIView()
        
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        labelTitle.text = getTitle()
        
        view.addSubview(labelTitle)
        
        return view
    }
    
    internal func getTitle() -> String {
        return ""
    }
}
