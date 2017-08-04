//
//  AppTableViewHeader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AppTableViewHeader: UIView {
    
    //MARK: abstract functions
    func getRowHeight() -> CGFloat {
        fatalError("must be implemented")
    }
    
}
