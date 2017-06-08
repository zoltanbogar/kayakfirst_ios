//
//  PECellSpace.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PECellSpace: AppUITableViewCell<PlanElement> {
    
    //MARK: properties
    private let view = UIView()
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: PlanElement?) {
        //nothing here
    }
    
    //MARK: init view
    override func initView() -> UIView {
        return view
    }
    
    override func getRowHeight() -> CGFloat {
        return margin
    }
}
