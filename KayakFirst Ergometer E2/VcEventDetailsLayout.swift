//
//  VcEventDetailsLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcEventDetailsLayout: BaseLayout {
    
    var datePickerView = UIDatePicker()
    var timePickerView = UIDatePicker()
    
    override func setView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = margin
        
        stackView.addArrangedSubview(labelTitle)
        stackView.addArrangedSubview(etDate)
        stackView.addArrangedSubview(etStart)
        stackView.addArrangedSubview(etName)
        
        labelTitle.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.width.equalTo(200)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
        }
    }
    
    //MARK: views
    lazy var etName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("plan_name")
        textField.active = false
        
        return textField
    }()
    
    lazy var etDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("date_date")
        textField.active = false
        
        return textField
    }()
    
    lazy var etStart: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("training_start")
        textField.active = false
        
        return textField
    }()
    
    lazy var labelTitle: AppUILabel! = {
        let label = AppUILabel()
        
        label.textAlignment = .center
        label.text = getString("plan_event_title")
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: barbuttons
    lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "save")
        
        return button
    }()
    
    lazy var btnDelete: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "trash")
        
        return button
    }()
    
    lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")
        
        return button
    }()
}
