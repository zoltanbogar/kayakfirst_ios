//
//  SetDashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SetDashboardVc: BaseVC {
    
    //MARK: properties
    private var snapShot: UIView?
    private var isDragEnded = true
    
    //MARK: lífecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleLongClick()
    }
    
    //MARK: longpress
    private func handleLongClick() {
        addGesutreRecognizer(dashBoardElement: dashboardElementActual200)
        addGesutreRecognizer(dashBoardElement: dashboardElementActual500)
        addGesutreRecognizer(dashBoardElement: dashboardElementActual1000)
        addGesutreRecognizer(dashBoardElement: dashboardElementAv200)
        addGesutreRecognizer(dashBoardElement: dashboardElementAv500)
        addGesutreRecognizer(dashBoardElement: dashboardElementAv1000)
        addGesutreRecognizer(dashBoardElement: dashboardElementAvSpeed)
        addGesutreRecognizer(dashBoardElement: dashboardElementAvStrokes)
        addGesutreRecognizer(dashBoardElement: dashboardElementCurrentSpeed)
        addGesutreRecognizer(dashBoardElement: dashboardElementDistance)
        addGesutreRecognizer(dashBoardElement: dashboardElementDuration)
        addGesutreRecognizer(dashBoardElement: dashboardElementStrokes)
    }
    
    private func addGesutreRecognizer(dashBoardElement: DashBoardElement) {
        dashBoardElement.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
    }
    
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        let view = gestureRecognizer.view! as! DashBoardElement
        
        viewDragDrop0.setDragEvent(superView: contentView, gestureRecognizer: gestureRecognizer)
        viewDragDrop1.setDragEvent(superView: contentView, gestureRecognizer: gestureRecognizer)
        viewDragDrop2.setDragEvent(superView: contentView, gestureRecognizer: gestureRecognizer)
        viewDragDrop3.setDragEvent(superView: contentView, gestureRecognizer: gestureRecognizer)
        viewDragDrop4.setDragEvent(superView: contentView, gestureRecognizer: gestureRecognizer)

        
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
                }
                isDragEnded = false
            }
            
        case UIGestureRecognizerState.changed:
            if let dragView = self.snapShot {
                dragView.center = locationInView
            }
        default:
            view.isSelected = false
            self.snapShot?.removeFromSuperview()
            self.snapShot = nil
            isDragEnded = true
        }
    }
    
    //MARK: views
    override func initView() {
        mainStackView.addArrangedSubview(viewTop)
        mainStackView.addArrangedSubview(viewBottom)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(margin05, margin05, margin05, margin05))
        }
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([btnDone], animated: true)
        self.navigationItem.setLeftBarButtonItems([btnClose], animated: true)
        
        self.title = getString("navigation_set_dashboard")
    }
    
    private lazy var mainStackView: UIStackView! = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = margin1_5
        
        return mainStackView
    }()
    
    private lazy var viewTop: UIView! = {
        let view = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = margin05
        
        let stackViewLeft = UIStackView()
        stackViewLeft.axis = .vertical
        stackViewLeft.distribution = .fillEqually
        stackViewLeft.spacing = margin05
        
        stackViewLeft.addArrangedSubview(self.viewDragDrop0)
        stackViewLeft.addArrangedSubview(self.viewDragDrop1)
        
        let stackViewRight = UIStackView()
        stackViewRight.axis = .vertical
        stackViewRight.distribution = .fillEqually
        stackViewRight.spacing = margin05
        
        stackViewRight.addArrangedSubview(self.viewDragDrop2)
        stackViewRight.addArrangedSubview(self.viewDragDrop3)
        stackViewRight.addArrangedSubview(self.viewDragDrop4)
        
        stackView.addArrangedSubview(stackViewLeft)
        stackView.addArrangedSubview(stackViewRight)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        return view
    }()
    
    private lazy var viewDragDrop0: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop1: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop2: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop3: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop4: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    private lazy var viewBottom: UIView! = {
        let view = UIView()
        let scrollView = AppScrollView(view: view)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = margin05
        
        let stackViewLeft = UIStackView()
        stackViewLeft.axis = .vertical
        stackViewLeft.distribution = .fillEqually
        stackViewLeft.spacing = margin05
        
        stackViewLeft.addArrangedSubview(self.dashboardElementDuration)
        stackViewLeft.addArrangedSubview(self.dashboardElementActual1000)
        stackViewLeft.addArrangedSubview(self.dashboardElementActual500)
        stackViewLeft.addArrangedSubview(self.dashboardElementActual200)
        stackViewLeft.addArrangedSubview(self.dashboardElementCurrentSpeed)
        stackViewLeft.addArrangedSubview(self.dashboardElementStrokes)
        
        let stackViewRight = UIStackView()
        stackViewRight.axis = .vertical
        stackViewRight.distribution = .fillEqually
        stackViewRight.spacing = margin05
        
        stackViewRight.addArrangedSubview(self.dashboardElementDistance)
        stackViewRight.addArrangedSubview(self.dashboardElementAv1000)
        stackViewRight.addArrangedSubview(self.dashboardElementAv500)
        stackViewRight.addArrangedSubview(self.dashboardElementAv200)
        stackViewRight.addArrangedSubview(self.dashboardElementAvSpeed)
        stackViewRight.addArrangedSubview(self.dashboardElementAvStrokes)
        
        stackView.addArrangedSubview(stackViewLeft)
        stackView.addArrangedSubview(stackViewRight)
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.containerView)
        }
        
        return view
    }()
    
    private lazy var dashboardElementActual200: DashBoardElement_Actual200! = {
        let view = DashBoardElement_Actual200()
        
        return view
    }()
    
    private lazy var dashboardElementActual500: DashBoardElement_Actual500! = {
        let view = DashBoardElement_Actual500()
        
        return view
    }()
    
    private lazy var dashboardElementActual1000: DashBoardElement_Actual1000! = {
        let view = DashBoardElement_Actual1000()
        
        return view
    }()
    
    private lazy var dashboardElementAv200: DashBoardElement_Av200! = {
        let view = DashBoardElement_Av200()
        
        return view
    }()
    
    private lazy var dashboardElementAv500: DashBoardElement_Av500! = {
        let view = DashBoardElement_Av500()
        
        return view
    }()
    
    private lazy var dashboardElementAv1000: DashBoardElement_Av1000! = {
        let view = DashBoardElement_Av1000()
        
        return view
    }()

    
    private lazy var dashboardElementAvSpeed: DashBoardElement_AvSpeed! = {
        let view = DashBoardElement_AvSpeed()
        
        return view
    }()
    
    private lazy var dashboardElementAvStrokes: DashBoardElement_AvStrokes! = {
        let view = DashBoardElement_AvStrokes()
        
        return view
    }()
    
    private lazy var dashboardElementCurrentSpeed: DashBoardElement_CurrentSpeed! = {
        let view = DashBoardElement_CurrentSpeed()
        
        return view
    }()
    
    private lazy var dashboardElementDistance: DashBoardElement_Distance! = {
        let view = DashBoardElement_Distance()
        
        return view
    }()
    
    private lazy var dashboardElementDuration: DashBoardElement_Duration! = {
        let view = DashBoardElement_Duration()
        
        return view
    }()
    
    private lazy var dashboardElementStrokes: DashBoardElement_Strokes! = {
        let view = DashBoardElement_Strokes()
        
        return view
    }()
    
    //MARK: tabbar items
    private lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_play_arrow_white_24dp")
        button.target = self
        button.action = #selector(btnDoneClick)
        
        return button
    }()
    
    private lazy var btnClose: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_clear_white_24dp")
        button.target = self
        button.action = #selector(btnCloseClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        if let parent = self.navigationController as? TrainingViewController {
            parent.showDashboard()
        }
    }
    
    @objc private func btnCloseClick() {
        dismiss(animated: true, completion: nil)
    }
}
