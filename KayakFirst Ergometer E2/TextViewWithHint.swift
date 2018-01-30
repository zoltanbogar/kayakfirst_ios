//
//  TextViewWithHint.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 30..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TextViewWithHint: UITextView, UITextViewDelegate {
    
    //MARK: properties
    var isHasText = false
    
    var hint: String? {
        didSet {
            setHintText(isHint: true, textShow: hint)
        }
    }
    
    //MARK: init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
         delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHintText(isHint: Bool, textShow: String?) {
        if isHint {
            text = hint
            textColor = Colors.colorGrey
        } else {
            text = textShow
            textColor = UIColor.black
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        isHasText = "" != textView.text && hint != textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setHintText(isHint: false, textShow: "")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let oldText = textView.text
        
        if oldText == "" {
            setHintText(isHint: true, textShow: hint)
        } else {
            setHintText(isHint: false, textShow: oldText)
        }
    }
    
}
