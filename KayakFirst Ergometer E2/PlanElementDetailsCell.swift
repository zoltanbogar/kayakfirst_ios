//
//  PlanDetailsCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 15..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanElementDetailsCell: AppUITableViewCell<PlanElement> {
    
    //MARK: properties
    private let baseView = UIView()
 
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: PlanElement?) {
        labelValue.text = data?.getFormattedValue()
        colorView.backgroundColor = getPlanElementColor(planElement: data)
        labelPercent.text = "\(data!.intensity)%"
    }
    
    //MARK: init view
    override func initView() -> UIView {
        baseView.addSubview(valueView)
        valueView.snp.makeConstraints { (make) in
            make.left.equalTo(baseView)
        }
        baseView.addSubview(percentView)
        percentView.snp.makeConstraints { (make) in
            make.right.equalTo(baseView)
        }
        
        baseView.backgroundColor = Colors.colorTransparent
        
        return baseView
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var valueView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.colorView)
        self.colorView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(self.getRowHeight())
        }
        
        view.addSubview(self.labelValue)
        self.labelValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.colorView.snp.right)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var labelValue: AppUILabel! = {
        let label = AppUILabel()
        
        return label
    }()
    
    private lazy var percentView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.labelPercent)
        self.labelPercent.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            //make.centerX.equalTo(view)
        }
        
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var labelPercent: AppUILabel! = {
        let label = AppUILabel()
        
        return label
    }()
    
    private lazy var colorView: UIView! = {
        let view = UIView()
        
        return view
    }()
    
}
