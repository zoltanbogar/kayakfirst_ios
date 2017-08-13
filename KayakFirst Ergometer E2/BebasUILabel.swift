//
//  BebasUILabel.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BebasUILabel: AppUILabel {
    
    internal override func initLabel() {
        super.initLabel()
        
        font = UIFont(name: "BebasNeue", size: 16)
    }
}
