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
    private var draggedViewOriginalX: CGFloat = 0
    private var draggedViewOriginalY: CGFloat = 0
    
    var withBluetooth = false
    
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
        addGesutreRecognizer(dashBoardElement: dashboardElementForce)
        addGesutreRecognizer(dashBoardElement: dashboardElementAvForce)
    }
    
    private func addGesutreRecognizer(dashBoardElement: DashBoardElement) {
        dashBoardElement.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
    }
    
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        let view = gestureRecognizer.view! as! DashBoardElement
        
        let didEnter0 = viewDragDrop0.setDragEvent(superView: mainStackView, gestureRecognizer: gestureRecognizer)
        let didEnter1 = viewDragDrop1.setDragEvent(superView: stackViewTop1, gestureRecognizer: gestureRecognizer)
        let didEnter2 = viewDragDrop2.setDragEvent(superView: stackViewTop1, gestureRecognizer: gestureRecognizer)
        let didEnter3 = viewDragDrop3.setDragEvent(superView: stackViewTop2, gestureRecognizer: gestureRecognizer)
        let didEnter4 = viewDragDrop4.setDragEvent(superView: stackViewTop2, gestureRecognizer: gestureRecognizer)
        
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
    //TODO: fonts not correct in bracnh 'BLE'
    override func initView() {
        mainStackView.removeAllSubviews()
        
        mainStackView.addArrangedSubview(viewTop)
        mainStackView.addArrangedSubview(viewBottom)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        contentView.backgroundColor = Colors.colorDashBoardDivider
    }
    
    override func handlePortraitLayout(size: CGSize) {
        mainStackView.axis = .vertical
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        mainStackView.axis = .horizontal
    }
    
    override func initTabBarItems() {
        var buttons: [UIBarButtonItem] = [btnDone]
        
        if let parent = self.parent as? TrainingViewController {
            if parent.trainingEnvType == TrainingEnvironmentType.ergometer {
                buttons.append(parent.bluetoothTabBarItem)
            }
        }
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
        
        //TODO: logo must show in center
        //showLogoOnLeft()
        
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
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        let stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.addArrangedSubview(self.dashboardElementActual1000)
        let halfDivider1 = HalfDivider()
        stackView1.addArrangedSubview(halfDivider1)
        stackView1.addArrangedSubview(self.dashboardElementActual500)
        let halfDivider2 = HalfDivider()
        stackView1.addArrangedSubview(halfDivider2)
        stackView1.addArrangedSubview(self.dashboardElementActual200)
        self.dashboardElementActual1000.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementActual500)
        })
        self.dashboardElementActual500.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementActual200)
        })
        self.dashboardElementActual200.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementActual1000)
        })
        halfDivider2.snp.makeConstraints({ (make) in
            make.width.equalTo(dashboardDividerWidth)
        })
        halfDivider1.snp.makeConstraints({ (make) in
            make.width.equalTo(halfDivider2)
        })
        
        
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.addArrangedSubview(self.dashboardElementAv1000)
        let halfDivider3 = HalfDivider()
        stackView2.addArrangedSubview(halfDivider3)
        stackView2.addArrangedSubview(self.dashboardElementAv500)
        let halfDivider4 = HalfDivider()
        stackView2.addArrangedSubview(halfDivider4)
        stackView2.addArrangedSubview(self.dashboardElementAv200)
        self.dashboardElementAv1000.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementAv500)
        })
        self.dashboardElementAv500.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementAv200)
        })
        self.dashboardElementAv200.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementAv1000)
        })
        halfDivider4.snp.makeConstraints({ (make) in
            make.width.equalTo(dashboardDividerWidth)
        })
        halfDivider3.snp.makeConstraints({ (make) in
            make.width.equalTo(halfDivider4)
        })
        
        let stackView3 = UIStackView()
        stackView3.axis = .horizontal
        stackView3.addArrangedSubview(self.dashboardElementDuration)
        let halfDivider5 = HalfDivider()
        stackView3.addArrangedSubview(halfDivider5)
        stackView3.addArrangedSubview(self.dashboardElementCurrentSpeed)
        let halfDivider6 = HalfDivider()
        stackView3.addArrangedSubview(halfDivider6)
        stackView3.addArrangedSubview(self.dashboardElementStrokes)
        self.dashboardElementDuration.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementCurrentSpeed)
        })
        self.dashboardElementCurrentSpeed.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementStrokes)
        })
        self.dashboardElementStrokes.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementDuration)
        })
        halfDivider6.snp.makeConstraints({ (make) in
            make.width.equalTo(dashboardDividerWidth)
        })
        halfDivider5.snp.makeConstraints({ (make) in
            make.width.equalTo(halfDivider6)
        })
        
        let stackView4 = UIStackView()
        stackView4.axis = .horizontal
        stackView4.addArrangedSubview(self.dashboardElementDistance)
        let halfDivider7 = HalfDivider()
        stackView4.addArrangedSubview(halfDivider7)
        stackView4.addArrangedSubview(self.dashboardElementAvSpeed)
        let halfDivider8 = HalfDivider()
        stackView4.addArrangedSubview(halfDivider8)
        stackView4.addArrangedSubview(self.dashboardElementAvStrokes)
        self.dashboardElementDistance.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementAvSpeed)
        })
        self.dashboardElementAvSpeed.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementAvStrokes)
        })
        self.dashboardElementAvStrokes.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementDistance)
        })
        halfDivider8.snp.makeConstraints({ (make) in
            make.width.equalTo(dashboardDividerWidth)
        })
        halfDivider7.snp.makeConstraints({ (make) in
            make.width.equalTo(halfDivider8)
        })
        
        let stackView5 = UIStackView()
        stackView5.axis = .horizontal
        stackView5.addArrangedSubview(self.dashboardElementForce)
        let halfDivider9 = HalfDivider()
        stackView5.addArrangedSubview(halfDivider9)
        stackView5.addArrangedSubview(self.imgLogo)
        let halfDivider10 = HalfDivider()
        stackView5.addArrangedSubview(halfDivider10)
        stackView5.addArrangedSubview(self.dashboardElementAvForce)
        self.dashboardElementForce.snp.makeConstraints({ (make) in
            make.width.equalTo(self.imgLogo)
        })
        self.imgLogo.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementAvForce)
        })
        self.dashboardElementAvForce.snp.makeConstraints({ (make) in
            make.width.equalTo(self.dashboardElementForce)
        })
        halfDivider9.snp.makeConstraints({ (make) in
            make.width.equalTo(dashboardDividerWidth)
        })
        halfDivider10.snp.makeConstraints({ (make) in
            make.width.equalTo(halfDivider9)
        })
        
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(stackView3)
        stackView.addArrangedSubview(stackView4)
        
        if self.withBluetooth {
            stackView.addArrangedSubview(stackView5)
        }
        
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
    
    private lazy var dashboardElementForce: DashBoardElement_PullForce! = {
        let view = DashBoardElement_PullForce()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var dashboardElementAvForce: DashBoardElement_AvPullForce! = {
        let view = DashBoardElement_AvPullForce()
        view.isValueVisible = false
        
        return view
    }()
    
    private lazy var imgLogo: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_header")
        imageView.clipsToBounds = true
        imageView.backgroundColor = Colors.colorPrimary
        imageView.contentMode = UIViewContentMode.center
        
        return imageView
    }()
    
    //MARK: tabbar items
    private lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")
        button.target = self
        button.action = #selector(btnDoneClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        if let parent = self.parent as? TrainingViewController {
            parent.showDashboard()
        }
    }
    
    override func backClick(sender: UIBarButtonItem) {
        if let parent = self.parent as? TrainingViewController {
            parent.closeViewController(shoudlCloseParents: false)
        }
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
