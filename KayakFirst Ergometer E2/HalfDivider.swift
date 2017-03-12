//
//  HalfDivider.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class HalfDivider: UIView {
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init views
    private func initView() {
        backgroundColor = Colors.colorPrimary
        let divider = UIView()
        divider.backgroundColor = Colors.colorDashBoardDivider
        
        addSubview(divider)
        divider.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(margin, 0, margin, 0))
        }
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: dashboardDividerWidth, height: 0)
        }
    }
    
}
