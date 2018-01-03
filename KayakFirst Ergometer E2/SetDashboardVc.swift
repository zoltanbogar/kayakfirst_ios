//
//  SetDashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SetDashboardVc: BaseVC<VcSetDashboardLayout> {
    
    //MARK: properties
    private var snapShot: UIView?
    private var isDragEnded = true
    private var draggedViewOriginalX: CGFloat = 0
    private var draggedViewOriginalY: CGFloat = 0
    
    var withBluetooth = false
    
    //MARK: lífecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleLongClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WindowHelper.setBrightness(isFull: true)
    }
    
    //MARK: longpress
    private func handleLongClick() {
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementActual200)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementActual500)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementActual1000)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementAv200)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementAv500)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementAv1000)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementAvSpeed)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementAvStrokes)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementCurrentSpeed)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementDistance)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementDuration)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementStrokes)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementForce)
        addGesutreRecognizer(dashBoardElement: contentLayout!.dashboardElementAvForce)
    }
    
    private func addGesutreRecognizer(dashBoardElement: DashBoardElement) {
        dashBoardElement.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
    }
    
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        let view = gestureRecognizer.view! as! DashBoardElement
        
        let didEnter0 = contentLayout!.viewDragDrop0.setDragEvent(superView: contentLayout!.mainStackView, gestureRecognizer: gestureRecognizer)
        let didEnter1 = contentLayout!.viewDragDrop1.setDragEvent(superView: contentLayout!.stackViewTop1, gestureRecognizer: gestureRecognizer)
        let didEnter2 = contentLayout!.viewDragDrop2.setDragEvent(superView: contentLayout!.stackViewTop1, gestureRecognizer: gestureRecognizer)
        let didEnter3 = contentLayout!.viewDragDrop3.setDragEvent(superView: contentLayout!.stackViewTop2, gestureRecognizer: gestureRecognizer)
        let didEnter4 = contentLayout!.viewDragDrop4.setDragEvent(superView: contentLayout!.stackViewTop2, gestureRecognizer: gestureRecognizer)
        
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
    
    //MARK: views
    override func initView() {
        super.initView()
        
        contentLayout?.btnDone.target = self
        contentLayout?.btnDone.action = #selector(btnDoneClick)
        contentLayout?.viewDragDrop0.viewAddedCallback = self.viewAdded
        contentLayout?.viewDragDrop1.viewAddedCallback = self.viewAdded
        contentLayout?.viewDragDrop2.viewAddedCallback = self.viewAdded
        contentLayout?.viewDragDrop3.viewAddedCallback = self.viewAdded
        contentLayout?.viewDragDrop4.viewAddedCallback = self.viewAdded
    }
    
    override func getContentLayout(contentView: UIView) -> VcSetDashboardLayout {
        return VcSetDashboardLayout(contentView: contentView, withBluetooth: withBluetooth)
    }
    
    override func initTabBarItems() {
        var buttons: [UIBarButtonItem] = [contentLayout!.btnDone]
        
        if let parent = self.parent as? TrainingViewControllerOld {
            if parent.trainingEnvType == TrainingEnvironmentType.ergometer {
                buttons.append(parent.bluetoothTabBarItem)
            }
        }
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
        
        showLogoOnLeft()
        
        self.title = getString("navigation_set_dashboard")
    }
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        if let parent = self.parent as? TrainingViewControllerOld {
            parent.showDashboard()
        }
    }
    
    override func backClick(sender: UIBarButtonItem) {
        if let parent = self.parent as? TrainingViewControllerOld {
            parent.closeViewController(shoudlCloseParents: false)
        }
    }
    
    private func viewAdded(dragDropLayout: DragDropLayout, tag: Int) {
        if let parent = self.navigationController as? TrainingViewControllerOld {
            
            var key = 0
            switch dragDropLayout {
            case contentLayout!.viewDragDrop0:
                key = 0
            case contentLayout!.viewDragDrop1:
                key = 1
            case contentLayout!.viewDragDrop2:
                key = 2
            case contentLayout!.viewDragDrop3:
                key = 3
            case contentLayout!.viewDragDrop4:
                key = 4
            default:
                fatalError()
            }
            
            parent.dashboardLayoutDict.updateValue(tag, forKey: key)
        }
    }
}
