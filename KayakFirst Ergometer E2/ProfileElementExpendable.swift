//
//  ProfileElementExpendable.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 31..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ProfileElementExpendable: BaseProfileElement<ViewProfileElementExpandableLayout>, UITextViewDelegate {
    
    //MARK: constants
    private let defaultHeight: CGFloat = 70
    
    var textHeightChangeListener: (() -> ())?
    
    override var active: Bool {
        get {
            return true
        }
        set {
            if newValue {
                contentLayout!.valueTextView.textColor = colorHighlitedDialogElement
                contentLayout!.labelTitle.textColor = colorHighlitedDialogElement
            } else {
                contentLayout!.valueTextView.textColor = textColorNormalValue
                contentLayout!.labelTitle.textColor = textColorNormalTitle
            }
            isEditable = newValue
            error = nil
        }
    }
    
    override var keyBoardType: UIKeyboardType? {
        get {
            return contentLayout!.valueTextView.keyboardType
        }
        set {
            contentLayout!.valueTextView.keyboardType = newValue!
        }
    }
    
    override var text: String? {
        get {
            return contentLayout!.valueTextView.text
        }
        set {
            contentLayout!.valueTextView.text = newValue
            
            layoutIfNeeded()
            
            self.error = nil
        }
    }
    
    override func initView() {
        super.initView()
        
        contentLayout!.valueTextView.textColor = self.textColorNormalValue
        contentLayout!.valueTextView.delegate = self
    }
    
    override func getContentLayout(contentView: UIView) -> ViewProfileElementExpandableLayout {
        return ViewProfileElementExpandableLayout(contentView: contentView)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if clickable {
            if let click = clickCallback {
                click()
            }
        }
        return isEditable
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let listener = textHeightChangeListener {
            listener()
        }
    }
}
