//
//  ProgressView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ProgressView: CustomUi<ViewProgressLayout> {
    
    init(superView: UIView) {
        super.init()
        
        superView.addSubview(contentLayout!.contentView)
        contentLayout!.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(superView)
        }
        
        show(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getContentLayout(contentView: UIView) -> ViewProgressLayout {
        return ViewProgressLayout(contentView: contentView)
    }
    
    func show(_ isShow: Bool) {
        contentLayout!.spinner.showProgressBar(isShow)
        
        isHidden = !isShow
    }
}
