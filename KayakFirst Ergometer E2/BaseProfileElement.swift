//
//  BaseProfileElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseProfileElement<E: ViewProfileElementLayout>: BaseDialogElementTextField<E> {
    
    //MARK: constants
    let textColorNormalValue = Colors.colorDashBoardDivider
    let textColorNormalTitle = Colors.colorWhite
    
    //MARK: properties
    override var title: String? {
        get {
            return contentLayout!.labelTitle.text
        }
        
        set {
            contentLayout!.labelTitle.text = newValue
        }
    }
    override var active: Bool {
        get {
            return true
        }
        set {
            if newValue {
                contentLayout!.valueTextField.textColor = colorHighlitedDialogElement
                contentLayout!.labelTitle.textColor = colorHighlitedDialogElement
            } else {
                contentLayout!.valueTextField.textColor = textColorNormalValue
                contentLayout!.labelTitle.textColor = textColorNormalTitle
            }
            isEditable = newValue
            isUserInteractionEnabled = newValue
            error = nil
        }
    }
    
    override func initView() {
        super.initView()
        
        contentLayout!.valueTextField.textColor = textColorNormalValue
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height:  profileElementHeight)
        }
    }
    
}
