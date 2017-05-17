//
//  PECellAdd.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PECellAdd: AppUITableViewCell<PlanElement> {
    
    //MARK: properties
    private let view = UIView()
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        setAppShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: PlanElement?) {
        //nothing here
    }
    
    //MARK: initView
    override func initView() -> UIView {
        view.addSubview(self.labelAdd)
        self.labelAdd.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        return view
    }
    
    override func getRowHeight() -> CGFloat {
        return planElementHeight
    }
    
    //MARK: views
    private lazy var labelAdd: UILabel! = {
        let label = UILabel()
        
        label.text = "+"
        
        return label
    }()
    
}
