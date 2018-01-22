//
//  VcFeedbackLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 22..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcFeedbackLayout: BaseLayout {
    
    override func setView() {
        //TODO
    }
    
    //MARK: tabbar items
    lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")?.withRenderingMode(.alwaysOriginal)
        
        return button
    }()
    
}
