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
    private let spaceHeight = margin05
    private let textSize: CGFloat = 35
    
    //MARK: properties
    private let baseView = UIView()
    private let stackView = UIStackView()
    var isEdit: Bool = false {
        didSet {
            editView.isHidden = !isEdit
        }
    }
 
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
            make.top.equalTo(baseView)
            make.height.equalTo(rowHeight)
            make.width.equalTo(270)
        }
        
        baseView.addSubview(percentView)
        percentView.snp.makeConstraints { (make) in
            make.top.equalTo(baseView)
            make.height.equalTo(rowHeight)
            make.right.equalTo(baseView)
            make.left.equalTo(valueView.snp.right).offset(margin05)
            make.width.equalTo(80)
        }
        percentView.addSubview(labelPercent)
        labelPercent.snp.makeConstraints { (make) in
            make.left.equalTo(percentView).offset(margin05)
            make.centerY.equalTo(percentView)
        }
        
        let spaceView = UIView()
        spaceView.backgroundColor = Colors.colorTransparent
        baseView.addSubview(spaceView)
        spaceView.snp.makeConstraints { (make) in
            make.top.equalTo(valueView.snp.bottom)
            make.left.equalTo(baseView)
            make.right.equalTo(baseView)
            make.height.equalTo(self.spaceHeight)
        }
        
        baseView.addSubview(editView)
        editView.snp.makeConstraints { (make) in
            make.edges.equalTo(baseView)
        }
        
        return baseView
    }
    
    override func getRowHeight() -> CGFloat {
        return rowHeight + spaceHeight
    }
    
    //MARK: views
    private lazy var valueView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.colorView)
        self.colorView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(margin)
            make.centerY.equalTo(view)
            let size = self.rowHeight - margin
            make.height.equalTo(size)
            make.width.equalTo(size)
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
    
    private lazy var editView: UIView! = {
        let view = UIView()
        
        view.backgroundColor = Colors.dragDropEnter
        
        view.isHidden = true
        
        return view
    }()
    
}
