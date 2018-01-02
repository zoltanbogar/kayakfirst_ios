//
//  ViewProgressLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewProgressLayout: BaseLayout {
    
    let spinner = AppProgressBar()
    
    override func setView() {
        contentView.backgroundColor = Colors.colorPrimaryTransparent
        
        contentView.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.width.equalTo(buttonHeight)
            make.height.equalTo(buttonHeight)
        }
    }
    
}
