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
            etDate.active = isEdit
            etStart.active = isEdit
            etNotes.active = isEdit
        }
    }
    var textHeightChangeListener: (() -> ())? {
        didSet {
            etNotes.textHeightChangeListener = self.textHeightChangeListener
        }
    }
    private var datePickerView = UIDatePicker()
    private var timePickerView = UIDatePicker()
    
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
        //TODO
        etName.text = data?.name
        etNotes.text = data?.notes
    }
    
    //MARK: init view
    override func initView() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = margin
        
        stackView.addArrangedSubview(etName)
        stackView.addArrangedSubview(etDate)
        stackView.addArrangedSubview(etDuration)
        stackView.addArrangedSubview(etStart)
        stackView.addArrangedSubview(etNotes)
        
        baseView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(baseView)
            make.right.equalTo(baseView)
            make.top.equalTo(baseView)
            make.height.equalTo(self.getHeight())
        }
        
        let marginView = UIView()
        marginView.backgroundColor = Colors.colorTransparent
        baseView.addSubview(marginView)
        marginView.snp.makeConstraints { (make) in
            make.left.equalTo(baseView)
            make.right.equalTo(baseView)
            make.top.equalTo(stackView.snp.bottom)
            make.height.equalTo(margin)
        }
        
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        timePickerView.datePickerMode = .time
        
        return baseView
    }
    
    override func getRowHeight() -> CGFloat {
        return getHeight() + margin
    }
    
    private func getHeight() -> CGFloat {
        return (etName.intrinsicContentSize.height) * 4 + etNotes.intrinsicContentSize.height
    }
    
    //MARK: views
    private lazy var etName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("plan_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("date_date")
        textField.active = false
        
        textField.valueTextField.inputView = self.datePickerView
        self.datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
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
        
        textField.valueTextField.inputView = self.timePickerView
        self.timePickerView.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return textField
    }()
    
    private lazy var etNotes: ProfileElementExpendable! = {
        let textField = ProfileElementExpendable()
        textField.title = getString("plan_notes")
        textField.active = false
        
        return textField
    }()
    
    //MARK: listener
    func datePickerValueChanged(sender: UIDatePicker) {
        
        log("DATE_TEST", "\(DateFormatHelper.getTimestampFromDatePicker(datePicker: sender))")
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        
        let timestamp = DateFormatHelper.getMilliSeconds(date: sender.date)
        
        log("DATE_TEST", "\(timestamp)")
    }
}
