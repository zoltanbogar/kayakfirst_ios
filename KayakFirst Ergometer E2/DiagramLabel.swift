//
//  DiagramLabel.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DiagramLabel: CustomUi<ViewDiagramLabelLayout>, UITextFieldDelegate {
    
    //MARK: constants
    private let defaultTextColor = Colors.colorWhite
    private let disabledTextColor = Colors.colorTransparent
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
    var isDisabled: Bool = false {
        didSet {
            if isDisabled {
                isSelected = false
            }
            refreshActive()
        }
    }
    
    //MARK: views
    override func initView() {
        super.initView()
        
        initLabel()
        
        contentLayout!.textField.delegate = self
        contentLayout!.textField.textColor = self.defaultTextColor
        contentLayout!.textField.text = self.title!.uppercased()
        
        initDefault()
    }
    
    override func getContentLayout(contentView: UIView) -> ViewDiagramLabelLayout {
        return ViewDiagramLabelLayout(contentView: contentView)
    }
    
    //MARK: abstract functions
    func getLabel() -> CalculateEnum {
        fatalError("Must be implemented")
    }
    
    //MARK: others
    private func refreshActive() {
        if !isDisabled {
            isSelected = !isSelected
            if isSelected {
                contentLayout!.textField.textColor = Colors.colorPrimary
                contentLayout!.textField.borderStyle = .roundedRect
                contentLayout!.textField.backgroundColor = color
            } else {
                contentLayout!.textField.textColor = defaultTextColor
                contentLayout!.textField.borderStyle = .none
                contentLayout!.textField.backgroundColor = UIColor.clear
            }
        } else {
            isHidden = true
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
    
    //MARK: callback
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        click()
        return false
    }
    
    private func click() {
        if !isDisabled {
            refreshActive()
            if let listener = labelSelectedListener {
                listener(self)
            }
        }
    }
    
}
