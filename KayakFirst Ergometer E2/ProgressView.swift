//
//  ProgressView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ProgressView: UIView {
    
    private let view = UIView()
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    init(superView: UIView) {
        super.init(frame: superView.frame)
        view.backgroundColor = Colors.colorPrimaryTransparent
        
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        superView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(superView)
        }
        
        show(isShow: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show(isShow: Bool) {
        if isShow {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        
        view.isHidden = !isShow
    }
    
}
