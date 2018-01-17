//
//  PEDashboardTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PEDashboardTableView: TableViewWithEmpty<PlanElement> {
    
    //MARK: properties
    private var planElementsOriginal: [PlanElement]?
    override var dataList: [PlanElement]? {
        didSet {
            if dataList != nil && planElementsOriginal == nil {
                planElementsOriginal = dataList!.map { $0 }
            }
            reloadData()
        }
    }
    
    private var showPosition: Int = 0
    
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
    func showPlanElementByPosition(position: Int) {
        if dataList != nil && showPosition != position {
            var newElements = [PlanElement]()
            
            for i in position..<planElementsOriginal!.count {
                newElements.append(planElementsOriginal![i])
            }
            dataList = newElements
            
            reloadData()
        }
        self.showPosition = position
    }
    
    override func getEmptyView() -> UIView {
        return labelEmpty
    }
    
    override func getCellClass() -> AnyClass {
        return PlanElementDetailsCell.self
    }
    
    //MARK: views
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.text = getString("plan_end")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        
        return label
    }()
    
}
