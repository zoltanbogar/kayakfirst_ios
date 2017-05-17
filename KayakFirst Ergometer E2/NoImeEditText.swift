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
        layer.borderWidth = dashboardDividerWidth
        layer.borderColor = Colors.colorDashBoardDivider.cgColor
        
        inputView = UIView()
    }
}
