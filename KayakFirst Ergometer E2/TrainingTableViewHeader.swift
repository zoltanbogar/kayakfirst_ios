//
//  TrainingTableViewHeader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingTableViewHeader: UIView {
    
    //MARK: contstants
    private let fontSize: CGFloat = 12

    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(labelType)
        stackView.addArrangedSubview(labelStart)
        stackView.addArrangedSubview(labelDuration)
        stackView.addArrangedSubview(labelDistance)
        stackView.addArrangedSubview(labelLog)
        
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
        
        backgroundColor = Colors.colorPrimary
    }
    
    //MARK: views
    private lazy var labelType: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("training_type").uppercased()
        
        return label
    }()
    
    private lazy var labelStart: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("training_start").uppercased()
        
        return label
    }()
    
    private lazy var labelDuration: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("training_duration").uppercased()
        
        return label
    }()
    
    private lazy var labelDistance: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("training_distance").uppercased()
        
        return label
    }()
    
    private lazy var labelLog: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = label.font.withSize(self.fontSize)
        
        label.text = getString("training_log").uppercased()
        
        return label
    }()
    
}
