//
//  ViewProfileElementExpandableLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewProfileElementExpandableLayout: ViewProfileElementLayout {
    
    override func setView() {
        contentView.backgroundColor = Colors.colorProfileElement
        
        contentView.addSubview(labelTitle)
        contentView.addSubview(valueTextView)
        contentView.addSubview(errorLabel)
        
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
        }
        
        valueTextView.snp.makeConstraints{ make in
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, margin))
            make.top.equalTo(labelTitle.snp.bottom)
            make.bottom.equalTo(contentView)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.equalTo(valueTextView)
            make.top.equalTo(valueTextView.snp.bottom)
            make.width.equalTo(contentView)
        }
    }
    
    //MARK: views
    lazy var valueTextView: UITextView! = {
        let view = UITextView()
        
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = false
        
        return view
    }()
    
}
