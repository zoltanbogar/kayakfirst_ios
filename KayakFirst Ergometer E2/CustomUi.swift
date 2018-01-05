//
//  CustomUi.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class CustomUi<E: BaseLayout>: UIView {
    
    var contentLayout: E?
    
    private let contentView = UIView()
    
    init() {
        super.init(frame: CGRect.zero)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    //MARK: abstract functions
    func getContentLayout(contentView: UIView) -> E {
        fatalError("Must be implemented")
    }
    
    func initView() {
        self.contentLayout = getContentLayout(contentView: self)
        self.contentLayout?.setView()
    }
    
}
