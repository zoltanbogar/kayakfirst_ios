//
//  PauseView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 04..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//MARK: delegate
protocol PauseViewDelegate {
    func onResumeClicked()
    func onStopClicked()
}

class PauseView: CustomUi<ViewPauseLayout> {
    
    //MARK: properties
    var delegate: PauseViewDelegate?
    
    //MARK: init
    init(superView: UIView) {
        super.init()
        
        superView.addSubview(contentLayout!.contentView)
        contentLayout!.contentView.snp.makeConstraints { make in
            make.edges.equalTo(superView)
        }
        
        show(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.btnPlay.addTarget(self, action: #selector(btnPlayClick), for: .touchUpInside)
        contentLayout!.btnStop.addTarget(self, action: #selector(btnStopClick), for: .touchUpInside)
    }
    
    override func getContentLayout(contentView: UIView) -> ViewPauseLayout {
        return ViewPauseLayout(contentView: contentView)
    }
    
    //MARK: functions
    func showPauseView() {
        show(true)
    }
    
    private func show(_ isShow: Bool) {
        isHidden = !isShow
    }
    
    //MARK: callbacks
    @objc private func btnPlayClick() {
        delegate?.onResumeClicked()
        show(false)
    }
    
    @objc private func btnStopClick() {
        delegate?.onStopClicked()
        show(false)
    }
    
    
    
}
