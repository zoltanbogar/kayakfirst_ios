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
    private let baseView = UIView()
    var isEdit: Bool = false {
        didSet {
            etName.active = isEdit
            etNotes.active = isEdit
        }
    }
    var textHeightChangeListener: (() -> ())? {
        didSet {
            etNotes.textHeightChangeListener = self.textHeightChangeListener
        }
    }
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
        selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: Plan?) {
        if etName.text == "" {
            etName.text = data?.name
        }
        if etNotes.text == "" {
            etNotes.text = data?.notes
        }
        etDuration.text = data?.getFormattedDuration()
    }
    
    //MARK: init view
    override func initView() -> UIView {
        baseView.addSubview(etName)
        baseView.addSubview(etDuration)
        baseView.addSubview(etNotes)
        
        etName.snp.makeConstraints { (make) in
            make.left.equalTo(baseView)
            make.right.equalTo(baseView)
            make.top.equalTo(baseView)
        }
        etDuration.snp.makeConstraints { (make) in
            make.left.equalTo(baseView)
            make.right.equalTo(baseView)
            make.top.equalTo(etName.snp.bottom).offset(margin)
        }
        etNotes.snp.makeConstraints { (make) in
            make.left.equalTo(baseView)
            make.right.equalTo(baseView)
            make.top.equalTo(etDuration.snp.bottom).offset(margin)
            make.bottom.equalTo(baseView).offset(-margin)
        }
        
        return baseView
    }
    
    override func getRowHeight() -> CGFloat {
        return getHeight() + margin
    }
    
    private func getHeight() -> CGFloat {
        return (etName.intrinsicContentSize.height) * 4 + etNotes.intrinsicContentSize.height
    }
    
    //MARK: views
    lazy var etName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("plan_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etDuration: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("dashboard_title_duration")
        textField.active = false
        
        return textField
    }()
    
    lazy var etNotes: ProfileElementExpendable! = {
        let textField = ProfileElementExpendable()
        textField.title = getString("plan_notes")
        textField.active = false
        
        return textField
    }()
}
