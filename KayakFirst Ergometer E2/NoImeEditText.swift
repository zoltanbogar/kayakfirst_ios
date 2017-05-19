//
//  NoImeEditText.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class NoImeEditText: UITextView {
    
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
