//
//  VcSetDsahboardLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcSetDashboardLayout: BaseLayout {
    
    private let withBluetooth: Bool
    
    init(contentView: UIView, withBluetooth: Bool) {
        self.withBluetooth = withBluetooth
        super.init(contentView: contentView)
    }
    
    override func setView() {
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
    
    //MARK: views
    lazy var mainStackView: UIStackView! = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = dashboardDividerWidth * 5
        
        return mainStackView
    }()
    
    lazy var viewTop: UIView! = {
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
    
    lazy var stackViewTop: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    lazy var stackViewTop1: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    lazy var stackViewTop2: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    lazy var viewDragDrop0: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    lazy var viewDragDrop1: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    lazy var viewDragDrop2: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    lazy var viewDragDrop3: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    lazy var viewDragDrop4: DragDropLayout! = {
        let viewDragDrop = DragDropLayout()
        
        return viewDragDrop
    }()
    
    lazy var viewBottom: UIView! = {
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
    
    lazy var dashboardElementActual200: DashBoardElement_Actual200! = {
        let view = DashBoardElement_Actual200()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementActual500: DashBoardElement_Actual500! = {
        let view = DashBoardElement_Actual500()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementActual1000: DashBoardElement_Actual1000! = {
        let view = DashBoardElement_Actual1000()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementAv200: DashBoardElement_Av200! = {
        let view = DashBoardElement_Av200()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementAv500: DashBoardElement_Av500! = {
        let view = DashBoardElement_Av500()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementAv1000: DashBoardElement_Av1000! = {
        let view = DashBoardElement_Av1000()
        view.isValueVisible = false
        
        return view
    }()
    
    
    lazy var dashboardElementAvSpeed: DashBoardElement_AvSpeed! = {
        let view = DashBoardElement_AvSpeed()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementAvStrokes: DashBoardElement_AvStrokes! = {
        let view = DashBoardElement_AvStrokes()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementCurrentSpeed: DashBoardElement_CurrentSpeed! = {
        let view = DashBoardElement_CurrentSpeed()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementDistance: DashBoardElement_Distance! = {
        let view = DashBoardElement_Distance()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementDuration: DashBoardElement_Duration! = {
        let view = DashBoardElement_Duration()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementStrokes: DashBoardElement_Strokes! = {
        let view = DashBoardElement_Strokes()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementForce: DashBoardElement_PullForce! = {
        let view = DashBoardElement_PullForce()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var dashboardElementAvForce: DashBoardElement_AvPullForce! = {
        let view = DashBoardElement_AvPullForce()
        view.isValueVisible = false
        
        return view
    }()
    
    lazy var imgLogo: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_header")
        imageView.clipsToBounds = true
        imageView.backgroundColor = Colors.colorPrimary
        imageView.contentMode = UIViewContentMode.center
        
        return imageView
    }()
    
    //MARK: tabbar items
    lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")
        
        return button
    }()
    
}
