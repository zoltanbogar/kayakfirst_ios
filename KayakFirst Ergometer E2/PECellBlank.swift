//
//  PECellAdd.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PECellBlank: AppUITableViewCell<PlanElement> {
    
    //MARK: properties
    private let view = UIView()
    
    var title: String? {
        didSet {
            labelAdd.text = title
        }
    }
    
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
    
    //MARK: initView
    override func initView() -> UIView {
        let spaceView = UIView()
        
        view.addSubview(spaceView)
        
        view.addSubview(planElementView)
        
        spaceView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(PECellNormal.shadowMargin)
        }
        
        planElementView.snp.makeConstraints { (make) in
            make.left.equalTo(spaceView.snp.right)
            make.top.equalTo(view).offset(PECellNormal.shadowMargin)
            make.right.equalTo(view).offset(-PECellNormal.shadowMargin)
            make.bottom.equalTo(view).offset(-PECellNormal.shadowMargin)
        }
        
        return view
    }
    
    override func getRowHeight() -> CGFloat {
        return planElementHeight + 2 * PECellNormal.shadowMargin
    }
    
    //MARK: views
    private lazy var planElementView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.labelAdd)
        self.labelAdd.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        view.layer.cornerRadius = planRadius
        view.backgroundColor = Colors.colorGrey
        view.setAppShadow()
        
        return view
    }()
    
    private lazy var labelAdd: UILabel! = {
        let label = BebasUILabel()
        
        label.textColor = UIColor.white
        
        label.text = "0"
        
        label.font = label.font.withSize(planElementCellTextSize)
        
        return label
    }()
    
}
