//
//  ViewDragDropLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewDragDropLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(imgAdd)
        imgAdd.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
        contentView.addSubview(newView)
        newView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        contentView.addSubview(viewDragDrop)
        viewDragDrop.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        contentView.backgroundColor = Colors.colorPrimary
    }
    
    lazy var imgAdd: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_add_white")
        
        return imageView
    }()
    
    lazy var viewDragDrop: UIView! = {
        let view = UIView()
        
        view.isHidden = true
        
        return view
    }()
    
    lazy var newView: UIView! = {
        let view = UIView()
        
        return view
    }()
    
}
