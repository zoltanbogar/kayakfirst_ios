//
//  DiagramLabel.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DiagramLabel: UIView, UITextFieldDelegate {
    
    //MARK: constants
    private let defaultTextColor = Colors.colorWhite
    private let defaultLabels: [CalculateEnum] = [CalculateEnum.STROKES, CalculateEnum.V, CalculateEnum.F, CalculateEnum.T_200]
    
    //MARK: properties
    private var isSelected = false
    private var color: UIColor?
    private var title: String?
    var isActive: Bool {
        get {
            return isSelected
        }
        set {
            isSelected = !newValue
            refreshActive()
        }
    }
    var labelSelectedListener: ((_ label: DiagramLabel) -> ())?
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        initLabel()
        initView()
        initDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: abstract functions
    func getLabel() -> CalculateEnum {
        fatalError("Must be implemented")
    }
    
    //MARK: others
    private func refreshActive() {
        isSelected = !isSelected
        if isSelected {
            textField.textColor = color
            textField.setBottomBorder(color!)
        } else {
            textField.textColor = defaultTextColor
            textField.removeBorderLine()
        }
    }
    
    private func initLabel() {
        color = CalculateEnum.getColor(calculate: getLabel())
        title = CalculateEnum.getTitle(calculate: getLabel())
    }
    
    private func initDefault() {
        for label in defaultLabels {
            if label == getLabel() {
                refreshActive()
            }
        }
    }
    
    //MARK: views
    private func initView() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private lazy var textField: UITextField! = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.delegate = self
        
        textField.textColor = self.defaultTextColor
        textField.text = self.title!
        
        return textField
    }()
    
    //MARK: callback
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        click()
        return false
    }
    
    private func click() {
        refreshActive()
        if let listener = labelSelectedListener {
            listener(self)
        }
    }
    
}
