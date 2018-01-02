//
//  ProgressView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ProgressView: CustomUi {
    
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
    
    override func getContentLayout(contentView: UIView) -> BaseLayout {
        return ViewProgressLayout(contentView: contentView)
    }
    
    func show(_ isShow: Bool) {
        (contentLayout as! ViewProgressLayout).spinner.showProgressBar(isShow)
        
        isHidden = !isShow
    }
}
