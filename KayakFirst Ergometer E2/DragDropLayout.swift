//
//  DragDropLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DragDropLayout: CustomUi<ViewDragDropLayout> {
    
    //MARK: properties
    var viewAddedCallback: ((_ dragDropLayout: DragDropLayout, _ tag: Int) ->())?
    
    override func getContentLayout(contentView: UIView) -> ViewDragDropLayout {
        return ViewDragDropLayout(contentView: contentView)
    }
    
    //MARK: dragdrop
    func setDragEvent(superView: UIView, gestureRecognizer: UIGestureRecognizer) -> Bool {
        var didEnter = false
        
        var color: UIColor?
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            color = Colors.dragDropStart
        case UIGestureRecognizerState.changed:
            if self.isDragDropEnter(superView: superView, gestureRecognizer: gestureRecognizer) {
                color = Colors.dragDropEnter
            } else {
                color = Colors.dragDropStart
            }
        case UIGestureRecognizerState.ended:
            if self.isDragDropEnter(superView: superView, gestureRecognizer: gestureRecognizer) {
                addNewView(tag: gestureRecognizer.view!.tag)
                
                didEnter = true
            } else {
                color = nil
            }
        default:
            color = nil
        }
        
        contentLayout!.viewDragDrop.backgroundColor = color
        contentLayout!.viewDragDrop.isHidden = color == nil
        
        return didEnter
    }
    
    private func addNewView(tag: Int) {
        contentLayout!.newView.removeAllSubviews()
        contentLayout!.imgAdd.isHidden = true
        
        let view = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: false)
        
        contentLayout!.newView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalTo(contentLayout!.newView)
        }
        
        if let callback = viewAddedCallback {
            callback(self, tag)
        }
    }
    
}
