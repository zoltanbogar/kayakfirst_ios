//
//  PlanDetailsCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 15..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanElementDetailsCell: AppUITableViewCell<PlanElement> {
    
    //MARK: constants
    private let rowHeight: CGFloat = 50
    private let textSize: CGFloat = 35
    
    //MARK: properties
    private let baseView = UIView()
    private let stackView = UIStackView()
 
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
        stackView.axis = .horizontal
        stackView.spacing = margin05
        
        stackView.addArrangedSubview(valueView)
        stackView.addArrangedSubview(percentView)
        
        valueView.snp.makeConstraints { (make) in
            make.width.equalTo(270)
        }
        percentView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
        }
        
        return stackView
    }
    
    override func getRowHeight() -> CGFloat {
        return rowHeight
    }
    
    //MARK: views
    private lazy var valueView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.colorView)
        self.colorView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(margin)
            make.top.equalTo(view).offset(margin05)
            make.bottom.equalTo(view).offset(-margin05)
            make.width.equalTo(self.rowHeight).inset(UIEdgeInsetsMake(0, 0, 0, -margin))
        }
        
        view.addSubview(self.labelValue)
        self.labelValue.snp.makeConstraints({ (make) in
            make.left.equalTo(self.colorView.snp.right)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        })
        
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var labelValue: AppUILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.textSize)
        
        return label
    }()
    
    private lazy var percentView: UIView! = {
        let percentV = UIView()
        
        //TODO: why this not work?
        /*percentV.addSubview(self.labelPercent)
        self.labelPercent.snp.makeConstraints { (make) in
            make.top.equalTo(percentV)
            make.bottom.equalTo(percentV)
            //make.left.equalTo(self.valueView.snp.right)
            //make.centerX.equalTo(view)
        }*/
        
        percentV.backgroundColor = UIColor.white
        
        return percentV
    }()
    
    private lazy var labelPercent: AppUILabel! = {
        let label = BebasUILabel()
        
        label.font = label.font.withSize(self.textSize)
        
        return label
    }()
    
    private lazy var colorView: UIView! = {
        let view = UIView()
        
        return view
    }()
    
}
