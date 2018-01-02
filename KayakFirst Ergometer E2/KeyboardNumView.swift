//
//  KeyboardNumView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol OnKeyboardClickedListener {
    func onClicked(value: Int)
}

class KeyboardNumView: CustomUi<ViewKeyboardNumLayout> {
    
    //MARK: constants
    static let valueBackSpace = -1
    static let valueNext = -2
    
    //MARK: properties
    var createPlanViewController: CreatePlanViewController?
    var keyboardClickListener: OnKeyboardClickedListener?
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        enableEnter(isEnable: false)
        
        //TODO: extension for UIButton: onClickListener, eithout .toucupinside
        contentLayout!.btn0.addTarget(self, action: #selector(btn0Click), for: .touchUpInside)
        contentLayout!.btn1.addTarget(self, action: #selector(btn1Click), for: .touchUpInside)
        contentLayout!.btn2.addTarget(self, action: #selector(btn2Click), for: .touchUpInside)
        contentLayout!.btn3.addTarget(self, action: #selector(btn3Click), for: .touchUpInside)
        contentLayout!.btn4.addTarget(self, action: #selector(btn4Click), for: .touchUpInside)
        contentLayout!.btn5.addTarget(self, action: #selector(btn5Click), for: .touchUpInside)
        contentLayout!.btn6.addTarget(self, action: #selector(btn6Click), for: .touchUpInside)
        contentLayout!.btn7.addTarget(self, action: #selector(btn7Click), for: .touchUpInside)
        contentLayout!.btn8.addTarget(self, action: #selector(btn8Click), for: .touchUpInside)
        contentLayout!.btn9.addTarget(self, action: #selector(btn9Click), for: .touchUpInside)
        contentLayout!.btnBackSpace.addTarget(self, action: #selector(btnBackSpaceClick), for: .touchUpInside)
        contentLayout!.btnNext.addTarget(self, action: #selector(btnNextClick), for: .touchUpInside)
    }
    
    override func getContentLayout(contentView: UIView) -> ViewKeyboardNumLayout {
        return ViewKeyboardNumLayout(contentView: contentView)
    }
    
    //MARK: functions
    func enableEnter(isEnable: Bool) {
        contentLayout!.btnNext.isEnabled = isEnable
        
        contentLayout!.btnNext.setTitleColor(Colors.colorGrey, for: .disabled)
    }
    
    //MARK: button listeners
    private func onClicked(value: Int) {
        if let vc = createPlanViewController {
            let focusedEt: PlanEditText? = vc.activeTextView as! PlanEditText?
            
            if let focusedEditText = focusedEt {
                let previousText = focusedEditText.text
                var newText = previousText
                
                if value >= 0 {
                    newText = previousText! + String(value)
                } else if value == KeyboardNumView.valueBackSpace {
                    if (previousText?.characters.count)! > 0 {
                        let endIndex = previousText!.index(previousText!.startIndex, offsetBy: (previousText!.characters.count - 1))
                        newText = previousText?.substring(to: endIndex)
                    }
                }
                focusedEditText.setTextValidate(newText: newText!)
            }
        }
        if let listener = keyboardClickListener {
            listener.onClicked(value: value)
        }
    }
    
    func btn1Click() {
        onClicked(value: 1)
    }
    
    func btn2Click() {
        onClicked(value: 2)
    }
    
    func btn3Click() {
        onClicked(value: 3)
    }
    
    func btn4Click() {
        onClicked(value: 4)
    }
    
    func btn5Click() {
        onClicked(value: 5)
    }
    
    func btn6Click() {
        onClicked(value: 6)
    }
    
    func btn7Click() {
        onClicked(value: 7)
    }
    
    func btn8Click() {
        onClicked(value: 8)
    }
    
    func btn9Click() {
        onClicked(value: 9)
    }
    
    func btnBackSpaceClick() {
        onClicked(value: KeyboardNumView.valueBackSpace)
    }
    
    func btn0Click() {
        onClicked(value: 0)
    }
    
    func btnNextClick() {
        onClicked(value: KeyboardNumView.valueNext)
    }
    
}
