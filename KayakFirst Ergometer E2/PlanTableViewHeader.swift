//
//  PlanTableViewHeader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanTableViewHeader: UIView {
    
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
        
        let marginView = WeightView(weight: 1)
        let playView = WeightView(weight: EventTabLeViewCell.playWeight)
        let typeView = WeightView(weight: EventTabLeViewCell.deleteWeight)
        let nameMarginView = WeightView(weight: EventTabLeViewCell.nameMarginWeight)
        let deleteView = WeightView(weight: 2)
        
        stackView.addArrangedSubview(marginView)
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(typeView)
        stackView.addArrangedSubview(nameMarginView)
        stackView.addArrangedSubview(labelName)
        stackView.addArrangedSubview(labelAddToCalendar)
        stackView.addArrangedSubview(deleteView)
        
        labelAddToCalendar.snp.makeConstraints { (make) in
            make.width.equalTo(75)
        }
        
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
            make.height.equalTo(50)
            make.bottom.equalTo(divider)
        }

    }
    
    //MARK: views
    private lazy var labelName: WeightLabel! = {
        let label = WeightLabel(weight: EventTabLeViewCell.nameWeight)
        label.numberOfLines = 0
        label.font = label.font.withSize(self.fontSize)
        label.textColor = Colors.colorWhite
        
        label.text = getString("plan_name").uppercased()
        
        return label
    }()
    
    private lazy var labelAddToCalendar: WeightLabel! = {
        let label = WeightLabel(weight: EventTabLeViewCell.deleteWeight)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = label.font.withSize(self.fontSize)
        label.textColor = Colors.colorWhite
        
        label.text = getString("plan_add_calendar").uppercased()
        
        return label
    }()
}
