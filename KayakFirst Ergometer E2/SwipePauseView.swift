//
//  SwipePauseView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 04..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//MARK: delegate
protocol SwipePauseViewDelegate {
    func onPauseCLicked()
}

class SwipePauseView: CustomUi<ViewSwipePauseLayout> {
    
    //MARK: properties
    private var btnPauseOriginalX: CGFloat = 0
    private var btnPauseOriginalY: CGFloat = 0
    
    var delegate: SwipePauseViewDelegate?
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.btnPause.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(animateBtnPause(pan:))))
    }
    
    override func getContentLayout(contentView: UIView) -> ViewSwipePauseLayout {
        return ViewSwipePauseLayout(contentView: contentView)
    }
    
    //MARK: animation
    @objc private func animateBtnPause(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self)
        
        switch pan.state {
        case .began:
            btnPauseOriginalX = pan.view!.center.x
            btnPauseOriginalY = pan.view!.center.y
        case .changed:
            var diffX = btnPauseOriginalX
            var diffY = btnPauseOriginalY
            
            var swipe: CGFloat = 0
            
            if contentLayout!.isLandscape {
                let diffYGlobal = pan.view!.center.y + translation.y
                diffY = diffYGlobal < btnPauseOriginalY ? diffYGlobal : btnPauseOriginalY
                swipe = btnPauseOriginalY - diffY
            } else {
                let diffXGlobal = pan.view!.center.x + translation.x
                diffX = diffXGlobal > btnPauseOriginalX ? diffXGlobal : btnPauseOriginalX
                swipe = abs(btnPauseOriginalX - diffX)
            }
            
            if swipe > (pauseViewSwipeArea - pauseViewHeight) {
                animateBtnPlayPauseToOriginal()
                if let delegateValue = delegate {
                    delegateValue.onPauseCLicked()
                }
            } else {
                pan.view!.center = CGPoint(x: diffX, y: diffY)
                pan.setTranslation(CGPoint.zero, in: self)
            }
        case .ended:
            animateBtnPlayPauseToOriginal()
        default:
            break
        }
    }
    
    private func animateBtnPlayPauseToOriginal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentLayout!.btnPause.center = CGPoint(x: self.btnPauseOriginalX, y: self.btnPauseOriginalY)
        })
    }
    
}
