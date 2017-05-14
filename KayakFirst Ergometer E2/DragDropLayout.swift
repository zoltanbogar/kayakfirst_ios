//
//  DragDropLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DragDropLayout: UIView {
    
    //MARK: properties
    var viewAddedCallback: ((_ dragDropLayout: DragDropLayout, _ tag: Int) ->())?
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: dragdrop
    func setDragEvent(superView: UIView, gestureRecognizer: UIGestureRecognizer) {
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
            } else {
                color = nil
            }
        default:
            color = nil
        }
        
        viewDragDrop.backgroundColor = color
        viewDragDrop.isHidden = color == nil
    }
    
    private func addNewView(tag: Int) {
        newView.removeAllSubviews()
        imgAdd.isHidden = true
        
        let view = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: false)
        
        newView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalTo(newView)
        }
        
        if let callback = viewAddedCallback {
            callback(self, tag)
        }
    }
    
    //MARK: views
    private func initView() {
        addSubview(imgAdd)
        imgAdd.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        addSubview(newView)
        newView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        addSubview(viewDragDrop)
        viewDragDrop.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        backgroundColor = Colors.colorPrimary
    }
    
    private lazy var imgAdd: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_add_white")
        
        return imageView
    }()
    
    private lazy var viewDragDrop: UIView! = {
        let view = UIView()
        
        view.isHidden = true
        
        return view
    }()
    
    private lazy var newView: UIView! = {
        let view = UIView()
        
        return view
    }()
}
