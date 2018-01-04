//
//  ViewSwipePauseLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 04..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewSwipePauseLayout: BaseLayout {
    
    //MARK: properties
    let dashboardPauseSwipeArea: CGFloat = 180
    
    //MARK: init views
    override func setView() {
        handlePortraitLayout(size: CGSize.zero)
        
        contentView.addSubview(viewSwipePause)
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardPauseSwipeArea)
            make.height.equalTo(75)
        }
        btnPause.snp.removeConstraints()
        btnPause.snp.makeConstraints { (make) in
            make.left.equalTo(viewSwipePause)
            make.centerY.equalTo(viewSwipePause)
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.width.equalTo(75)
            make.height.equalTo(dashboardPauseSwipeArea)
        }
        btnPause.snp.removeConstraints()
        btnPause.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewSwipePause)
            make.centerX.equalTo(viewSwipePause)
        }
    }
    
    //MARK: views
    lazy var viewSwipePause: UIView! = {
        let view = UIView()
        view.layer.cornerRadius = 75 / 2
        
        view.addSubview(self.btnPause)
        
        view.backgroundColor = Colors.colorPauseBackground
        
        return view
    }()
    
    lazy var btnPause: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_pause_white_48pt")!, color: Colors.colorAccent)
        button.layer.cornerRadius = 75 / 2
        
        return button
    }()
    
}
