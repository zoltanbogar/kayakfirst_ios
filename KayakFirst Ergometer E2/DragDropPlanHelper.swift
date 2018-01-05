//
//  DragDropPlanHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 05..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//MARK: delegate
protocol DragDropPlanHelperDelegate {
    func shouldDelete(position: Int)
}

class DragDropPlanHelper {
    
    //MARK: properties
    var delegate: DragDropPlanHelperDelegate?
    
    private let contentLayout: VcCreatePlanLayout
    private let contentView: UIView
    
    private var snapShot: UIView?
    private var draggedView: UIView?
    private var indexPath: IndexPath?
    private var isDragEnded = true
    private var shouldDelete = false
    private var draggedViewOriginalX: CGFloat = 0
    private var draggedViewOriginalY: CGFloat = 0
    
    //MARK: init
    init(contentLayout: VcCreatePlanLayout, contentView: UIView) {
        self.contentLayout = contentLayout
        self.contentView = contentView
    }
    
    //MARK: functions
    func activate(gestureRecognizer: UIGestureRecognizer) {
        contentLayout.planElementTableView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: drag drop
    func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            
            let tableLocation = gestureRecognizer.location(in: contentLayout.planElementTableView)
            indexPath = contentLayout.planElementTableView.indexPathForRow(at: tableLocation)
            draggedView = contentLayout.planElementTableView.cellForRow(at: indexPath!) as! UITableViewCell
            
            if draggedView is PECellNormal {
                if isDragEnded {
                    if self.snapShot == nil {
                        
                        self.snapShot?.layer.cornerRadius = draggedView?.layer.cornerRadius ?? 0
                        
                        contentLayout.viewDelete.isHidden = false
                        
                        self.draggedViewOriginalX = locationInView.x
                        self.draggedViewOriginalY = locationInView.y
                        
                        self.snapShot = draggedView!.getSnapshotView()
                        self.contentView.addSubview(self.snapShot!)
                        self.snapShot!.snp.makeConstraints { make in
                            make.center.equalTo(locationInView)
                        }
                        draggedView?.isHidden = true
                    }
                    isDragEnded = false
                }
            }
        case UIGestureRecognizerState.changed:
            if let dragView = self.snapShot {
                dragView.center = locationInView
                
                shouldDelete = contentLayout.viewDelete.isDragDropEnter(superView: contentView, gestureRecognizer: gestureRecognizer)
            }
        default:
            if shouldDelete {
                resetDrag()
                contentLayout.planElementTableView.deletePlanElement(position: (indexPath?.row)!)
            } else {
                animateDraggedViewToOriginal()
            }
            shouldDelete = false
        }
    }
    
    private func animateDraggedViewToOriginal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.snapShot?.center = CGPoint(x: self.draggedViewOriginalX, y: self.draggedViewOriginalY)
        }, completion: { ended in
            self.resetDrag()
        })
    }
    
    private func resetDrag() {
        self.snapShot?.removeFromSuperview()
        self.draggedView?.isHidden = false
        self.snapShot = nil
        self.draggedView = nil
        self.isDragEnded = true
        contentLayout.viewDelete.isHidden = true
    }
    
}
