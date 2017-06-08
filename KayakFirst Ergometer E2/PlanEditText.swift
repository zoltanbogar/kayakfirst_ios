//
//  NoImeEditText.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum PlanTextType: String {
    case distance = "distance"
    case minute = "minute"
    case sec = "sec"
    case intensity = "intensity"
}

protocol OnTextChangedListener {
    func onTextChanged(etType: PlanTextType, hasText: Bool)
}

protocol OnFocusedListener {
    func hasFocus(planEditText: PlanEditText)
}

class PlanEditText: UITextView, UITextViewDelegate {
    
    //MARK: properties
    var hint: String? {
        didSet {
            text = hint
        }
    }
    var isHasText = false
    var onTextChangedListener: OnTextChangedListener?
    var onFocusedListener: OnFocusedListener?
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        
        delegate = self
        
        addContentSizeObserver()
        
        initView()
        
        font = UIFont(name: "BebasNeue", size: 16)
        textAlignment = .center
        textContainer.maximumNumberOfLines = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: abstract funtions
    func isTextValid(text: String) -> Bool {
        fatalError("Must be implemented")
    }
    func getType() -> PlanTextType {
        fatalError("Must be implemented")
    }
    
    //MARK: functions
    func setTextValidate(newText: String) {
        if isTextValid(text: newText) {
            text = newText
        }
    }
    
    //MARK: delegate
    func textViewDidChangeSelection(_ textView: UITextView) {
        isHasText = "" != textView.text && hint != textView.text
        
        if let listener = onTextChangedListener {
            listener.onTextChanged(etType: getType(), hasText: isHasText)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let listener = onFocusedListener {
            listener.hasFocus(planEditText: self)
        }
        
        text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let oldText = textView.text
        
        if oldText == "" {
            text = hint
        } else {
            text = oldText
        }
    }
    
    //MARK: init view
    private func initView() {
        backgroundColor = UIColor.white
        
        showAppBorder()
        
        inputView = UIView()
    }
    
    //TODO: not vertically centered the text
    private func addContentSizeObserver() {
        self.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    private func removeContentSizeObserver() {
        self.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var top = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        top = top < 0.0 ? 0.0 : top
        contentOffset = CGPoint(x: contentOffset.x, y: -top)
    }
    
    deinit {
        removeContentSizeObserver()
    }
}
