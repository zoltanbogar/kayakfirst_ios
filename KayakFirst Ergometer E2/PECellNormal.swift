//
//  PECellNormal.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PECellNormal: AppUITableViewCell<PlanElement> {
    
    //MARK: constants
    static let shadowMargin: CGFloat = 5
    
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
        label.text = data?.getFormattedValue()
        planElementView.backgroundColor = getPlanElementColor(planElement: data)
    }
    
    //MARK: init view
    override func initView() -> UIView {
        view.addSubview(planElementView)

        planElementView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(PECellNormal.shadowMargin)
            make.top.equalTo(view).offset(PECellNormal.shadowMargin)
            make.right.equalTo(view).offset(-PECellNormal.shadowMargin)
            make.bottom.equalTo(view).offset(-PECellNormal.shadowMargin)
        }
        
        return view
    }
    
    override func getRowHeight() -> CGFloat {
        return planElementHeight
    }
    
    //MARK: views
    private lazy var planElementView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        view.layer.cornerRadius = planRadius
        view.setAppShadow()
        
        return view
    }()
    
    private lazy var label: UILabel! = {
        let label = BebasUILabel()
        label.textColor = UIColor.white
        
        label.font = label.font.withSize(planElementCellTextSize)
        
        return label
    }()
}
