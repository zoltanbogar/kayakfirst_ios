//
//  DragDropLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DragDropLayout: RoundedBorderView {
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: views
    private func initView() {
        isDashed = true
        
        addSubview(imgAdd)
        imgAdd.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    private lazy var imgAdd: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_add_white")
        
        return imageView
    }()
}
