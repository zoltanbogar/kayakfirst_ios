//
//  PlanElementTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanElementTableView: TableViewWithEmpty<PlanElement> {
    
    //MARK: properties
    private let emptyView = UIView()
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: functions
    override func getEmptyView() -> UIView {
        return emptyView
    }
    
    override func getCellClass() -> AnyClass {
        return PECellNormal.self
    }
    
    func deletePlanElement(position: Int) {
        if dataList != nil {
            dataList!.remove(at: position)
            reloadData()
        }
    }
}
