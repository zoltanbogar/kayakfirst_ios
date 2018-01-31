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

class PlanEditText: TextViewWithHint {
    
    //MARK: properties
    var onTextChangedListener: OnTextChangedListener?
    var onFocusedListener: OnFocusedListener?
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        
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
            setHintText(isHint: false, textShow: newText)
        }
    }
    
    //MARK: delegate
    override func textViewDidChangeSelection(_ textView: UITextView) {
        super.textViewDidChangeSelection(textView)
        
        if let listener = onTextChangedListener {
            listener.onTextChanged(etType: getType(), hasText: isHasText)
        }
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        setHintText(isHint: false, textShow: "")
        
        if let listener = onFocusedListener {
            listener.hasFocus(planEditText: self)
        }
    }
    
    //MARK: init view
    private func initView() {
        backgroundColor = UIColor.white
        
        showAppBorder()
        
        layer.cornerRadius = planRadius
        
        inputView = UIView()
    }
    
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
