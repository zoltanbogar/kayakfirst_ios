//
//  PlanDetailsCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 15..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanDetailsCell: AppUITableViewCell<Plan> {
    
    //MARK: properties
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
    override func initData(data: Plan?) {
        //TODO
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = margin
        
        stackView.addArrangedSubview(tfName)
        stackView.addArrangedSubview(etDate)
        stackView.addArrangedSubview(etDuration)
        stackView.addArrangedSubview(etStart)
        stackView.addArrangedSubview(etNotes)
        
        return stackView
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var tfName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("plan_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("date_date")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etDuration: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("dashboard_title_duration")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etStart: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("training_start")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etNotes: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("plan_notes")
        textField.active = false
        
        return textField
    }()
    
}
