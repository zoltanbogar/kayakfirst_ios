//
//  PlanTablewViewHeader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventTableViewHeader: UIView {
    
    //MARK: contstants
    private let fontSize: CGFloat = 10
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        
        initView()
        
        backgroundColor = Colors.colorPrimary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        let playView = WeightView(weight: EventTabLeViewCell.playWeight)
        let nameMarginView = WeightView(weight: EventTabLeViewCell.nameMarginWeight * 2)
        let deleteView = WeightView(weight: EventTabLeViewCell.deleteWeight)
        
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(nameMarginView)
        stackView.addArrangedSubview(labelName)
        stackView.addArrangedSubview(labelDone)
        stackView.addArrangedSubview(deleteView)
        
        let divider = DividerView()
        addSubview(divider)
        divider.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(dashboardDividerWidth)
            make.top.equalTo(self.snp.bottom)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(divider)
        }
    }
    
    //MARK: views
    private lazy var labelName: WeightLabel! = {
        let label = WeightLabel(weight: EventTabLeViewCell.nameWeight)
        label.numberOfLines = 1
        label.textColor = Colors.colorWhite
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("plan_name").uppercased()
        
        return label
    }()
    
    private lazy var labelDone: WeightLabel! = {
        let label = WeightLabel(weight: EventTabLeViewCell.doneWeight)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = Colors.colorWhite
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("plan_done").uppercased()
        
        label.snp.makeConstraints({ (make) in
            make.width.equalTo(EventTabLeViewCell.doneWidth)
        })
        
        return label
    }()
}
