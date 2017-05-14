//
//  PECellNormal.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PECellNormal: AppUITableViewCell<PlanElement> {
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: PlanElement?) {
        label.text = data?.getFormattedValue()
        backgroundColor = getPlanElementColor(planElement: data)
        
        selectionColor = backgroundColor!
    }
    
    //MARK: init view
    override func initView() -> UIView {
        return planElementView
    }
    
    override func getRowHeight() -> CGFloat {
        return CGFloat(80)
    }
    
    //MARK: views
    private lazy var planElementView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        return view
    }()
    
    private lazy var label: UILabel! = {
        let label = UILabel()
        
        return label
    }()
}
