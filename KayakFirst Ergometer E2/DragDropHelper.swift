//
//  DragDropHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DragDropHelper {
    
    //MARK: properties
    private var snapShot: UIView?
    private var isDragEnded = true
    private var draggedViewOriginalX: CGFloat = 0
    private var draggedViewOriginalY: CGFloat = 0
    
    private let contentLayout: VcSetDashboardLayout
    private let contentView: UIView
    
    var dashboardLayoutDict: [Int:Int] =
        [0: DashBoardElement_Strokes.tagInt,
         1: DashBoardElement_Actual1000.tagInt,
         2: DashBoardElement_Av1000.tagInt,
         3: DashBoardElement_Duration.tagInt,
         4: DashBoardElement_Distance.tagInt]
    
    //MARK: init
    init(contentLayout: VcSetDashboardLayout) {
        self.contentLayout = contentLayout
        self.contentView = contentLayout.contentView
        
        let dashboardElements: [DashBoardElement] = [
            contentLayout.dashboardElementActual200,
            contentLayout.dashboardElementActual500,
            contentLayout.dashboardElementActual1000,
            contentLayout.dashboardElementAv200,
            contentLayout.dashboardElementAv500,
            contentLayout.dashboardElementAv1000,
            contentLayout.dashboardElementAvSpeed,
            contentLayout.dashboardElementAvStrokes,
            contentLayout.dashboardElementCurrentSpeed,
            contentLayout.dashboardElementDistance,
            contentLayout.dashboardElementDuration,
            contentLayout.dashboardElementStrokes,
            contentLayout.dashboardElementForce,
            contentLayout.dashboardElementAvForce]
        
        let dragDropLayouts: [DragDropLayout] = [
            contentLayout.viewDragDrop0,
            contentLayout.viewDragDrop1,
            contentLayout.viewDragDrop2,
            contentLayout.viewDragDrop3,
            contentLayout.viewDragDrop4
        ]
        
        setAttrs(dragDropLayouts: dragDropLayouts, dashboardElements: dashboardElements)
    }
    
    //MARK: functions
    private func setAttrs(dragDropLayouts: [DragDropLayout], dashboardElements: [DashBoardElement]) {
        dashboardElements.forEach { dashboardElement in
            addGesutreRecognizer(dashBoardElement: dashboardElement)
        }
        dragDropLayouts.forEach { dragDropLayout in
            dragDropLayout.viewAddedCallback = self.viewAdded
        }
    }
    
    private func addGesutreRecognizer(dashBoardElement: DashBoardElement) {
        dashBoardElement.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
    }
    
    private func viewAdded(dragDropLayout: DragDropLayout, tag: Int) {
        var key = 0
        switch dragDropLayout {
        case contentLayout.viewDragDrop0:
            key = 0
        case contentLayout.viewDragDrop1:
            key = 1
        case contentLayout.viewDragDrop2:
            key = 2
        case contentLayout.viewDragDrop3:
            key = 3
        case contentLayout.viewDragDrop4:
            key = 4
        default:
            fatalError()
        }
        
        dashboardLayoutDict.updateValue(tag, forKey: key)
    }
    
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        let view = gestureRecognizer.view! as! DashBoardElement
        
        let didEnter0 = contentLayout.viewDragDrop0.setDragEvent(superView: contentLayout.mainStackView, gestureRecognizer: gestureRecognizer)
        let didEnter1 = contentLayout.viewDragDrop1.setDragEvent(superView: contentLayout.stackViewTop1, gestureRecognizer: gestureRecognizer)
        let didEnter2 = contentLayout.viewDragDrop2.setDragEvent(superView: contentLayout.stackViewTop1, gestureRecognizer: gestureRecognizer)
        let didEnter3 = contentLayout.viewDragDrop3.setDragEvent(superView: contentLayout.stackViewTop2, gestureRecognizer: gestureRecognizer)
        let didEnter4 = contentLayout.viewDragDrop4.setDragEvent(superView: contentLayout.stackViewTop2, gestureRecognizer: gestureRecognizer)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            if isDragEnded {
                if self.snapShot == nil {
                    self.snapShot = view.getSnapshotView()
                    self.contentView.addSubview(self.snapShot!)
                    self.snapShot!.snp.makeConstraints { make in
                        make.center.equalTo(locationInView)
                    }
                    view.isSelected = true
                    
                    self.draggedViewOriginalX = locationInView.x
                    self.draggedViewOriginalY = locationInView.y
                }
                isDragEnded = false
            }
            
        case UIGestureRecognizerState.changed:
            if let dragView = self.snapShot {
                dragView.center = locationInView
            }
        default:
            if !didEnter0 && !didEnter1 && !didEnter2 && !didEnter3 && !didEnter4 {
                animateDraggedViewToOriginal()
            } else {
                resetDrag()
            }
            view.isSelected = false
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
        self.snapShot = nil
        isDragEnded = true
    }
}
