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
        
        viewDragDrop0.setDragEvent(superView: mainStackView, gestureRecognizer: gestureRecognizer)
        viewDragDrop1.setDragEvent(superView: stackViewTop1, gestureRecognizer: gestureRecognizer)
        viewDragDrop2.setDragEvent(superView: stackViewTop1, gestureRecognizer: gestureRecognizer)
        viewDragDrop3.setDragEvent(superView: stackViewTop2, gestureRecognizer: gestureRecognizer)
        viewDragDrop4.setDragEvent(superView: stackViewTop2, gestureRecognizer: gestureRecognizer)
        
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
            make.edges.equalTo(contentView)
        }
        contentView.backgroundColor = Colors.colorDashBoardDivider
    }
    
    override func handlePortraitLayout() {
        super.handlePortraitLayout()
        
        mainStackView.axis = .vertical
    }
    
    override func handleLandscapeLayout() {
        super.handleLandscapeLayout()
        
        mainStackView.axis = .horizontal
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
        mainStackView.spacing = dashboardDividerWidth * 5
        
        return mainStackView
    }()
    
    private lazy var viewTop: UIView! = {
        let view = UIView()
        
        self.stackViewTop.addArrangedSubview(self.viewDragDrop0)
        
        self.stackViewTop1.addArrangedSubview(self.viewDragDrop1)
        self.stackViewTop1.addArrangedSubview(self.viewDragDrop2)
        
        self.stackViewTop2.addArrangedSubview(self.viewDragDrop3)
        self.stackViewTop2.addArrangedSubview(self.viewDragDrop4)
        
        self.stackViewTop.addArrangedSubview(self.stackViewTop1)
        self.stackViewTop.addArrangedSubview(self.stackViewTop2)
        
        view.addSubview(self.stackViewTop)
        self.stackViewTop.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        return view
    }()
    
    private lazy var stackViewTop: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var stackViewTop1: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var stackViewTop2: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var viewDragDrop0: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        viewDragDrop.viewAddedCallback = self.viewAdded
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop1: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        viewDragDrop.viewAddedCallback = self.viewAdded
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop2: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        viewDragDrop.viewAddedCallback = self.viewAdded
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop3: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        viewDragDrop.viewAddedCallback = self.viewAdded
        
        return viewDragDrop
    }()
    
    private lazy var viewDragDrop4: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        viewDragDrop.viewAddedCallback = self.viewAdded
        
        return viewDragDrop
    }()
    
    private lazy var viewBottom: UIView! = {
        let view = UIView()
    
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        let stackViewLeft = UIStackView()
        stackViewLeft.axis = .vertical
        stackViewLeft.distribution = .fillEqually
        stackViewLeft.spacing = dashboardDividerWidth
        
        stackViewLeft.addArrangedSubview(self.dashboardElementDuration)
        stackViewLeft.addArrangedSubview(self.dashboardElementActual1000)
        stackViewLeft.addArrangedSubview(self.dashboardElementAv1000)
        stackViewLeft.addArrangedSubview(self.dashboardElementCurrentSpeed)
        
        let stackViewCenter = UIStackView()
        stackViewCenter.axis = .vertical
        stackViewCenter.distribution = .fillEqually
        stackViewCenter.spacing = dashboardDividerWidth
        
        stackViewCenter.addArrangedSubview(self.dashboardElementDistance)
        stackViewCenter.addArrangedSubview(self.dashboardElementActual500)
        stackViewCenter.addArrangedSubview(self.dashboardElementAv500)
        stackViewCenter.addArrangedSubview(self.dashboardElementAvSpeed)
        
        let stackViewRight = UIStackView()
        stackViewRight.axis = .vertical
        stackViewRight.distribution = .fillEqually
        stackViewRight.spacing = dashboardDividerWidth
        
        stackViewRight.addArrangedSubview(self.dashboardElementStrokes)
        stackViewRight.addArrangedSubview(self.dashboardElementActual200)
        stackViewRight.addArrangedSubview(self.dashboardElementAv200)
        stackViewRight.addArrangedSubview(self.dashboardElementAvStrokes)
        
        stackView.addArrangedSubview(stackViewLeft)
        stackView.addArrangedSubview(stackViewCenter)
        stackView.addArrangedSubview(stackViewRight)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        return view
    }()
    
    private lazy var dashboardElementActual200: DashBoardElement_Actual200! = {
        let view = DashBoardElement_Actual200()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementActual500: DashBoardElement_Actual500! = {
        let view = DashBoardElement_Actual500()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementActual1000: DashBoardElement_Actual1000! = {
        let view = DashBoardElement_Actual1000()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementAv200: DashBoardElement_Av200! = {
        let view = DashBoardElement_Av200()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementAv500: DashBoardElement_Av500! = {
        let view = DashBoardElement_Av500()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementAv1000: DashBoardElement_Av1000! = {
        let view = DashBoardElement_Av1000()
        view.isValueVisible = false
        
        return view
    }()

    
    private lazy var dashboardElementAvSpeed: DashBoardElement_AvSpeed! = {
        let view = DashBoardElement_AvSpeed()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementAvStrokes: DashBoardElement_AvStrokes! = {
        let view = DashBoardElement_AvStrokes()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementCurrentSpeed: DashBoardElement_CurrentSpeed! = {
        let view = DashBoardElement_CurrentSpeed()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementDistance: DashBoardElement_Distance! = {
        let view = DashBoardElement_Distance()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementDuration: DashBoardElement_Duration! = {
        let view = DashBoardElement_Duration()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementStrokes: DashBoardElement_Strokes! = {
        let view = DashBoardElement_Strokes()
        view.isValueVisible = false
        
        return view
    }()
    
    //MARK: tabbar items
    private lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")
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
        if let parent = self.parent as? TrainingViewController {
            parent.showDashboard()
        }
    }
    
    @objc private func btnCloseClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func viewAdded(dragDropLayout: DragDropLayout, tag: Int) {
        if let parent = self.navigationController as? TrainingViewController {
            
            var key = 0
            switch dragDropLayout {
            case self.viewDragDrop0:
                key = 0
            case self.viewDragDrop1:
                key = 1
            case self.viewDragDrop2:
                key = 2
            case self.viewDragDrop3:
                key = 3
            case self.viewDragDrop4:
                key = 4
            default:
                fatalError()
            }
            
            parent.dashboardLayoutDict.updateValue(tag, forKey: key)
        }
    }
}
