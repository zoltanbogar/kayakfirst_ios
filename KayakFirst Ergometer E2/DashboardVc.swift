//
//  DashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashboardVc: BaseVC {
    
    //MARK: views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        stackView.addArrangedSubview(view0)
        
        let stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        stackView1.spacing = dashboardDividerWidth
        
        stackView1.addArrangedSubview(view1)
        stackView1.addArrangedSubview(view2)
        
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.distribution = .fillEqually
        stackView2.spacing = dashboardDividerWidth
        
        stackView2.addArrangedSubview(view3)
        stackView2.addArrangedSubview(view4)
        
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        
        buttonView.addSubview(btnPlayPause)
        btnPlayPause.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }
        
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(buttonView)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        initDashboardViews()
        contentView.backgroundColor = Colors.colorDashBoardDivider
    }
    
    private func initDashboardViews() {
        if let parent = self.navigationController as? TrainingViewController {
            for (position, tag) in parent.dashboardLayoutDict {
                let dashboardElement = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: true)
                var view: UIView?
                switch position {
                case 0:
                    view = view0
                case 1:
                    view = view1
                case 2:
                    view = view2
                case 3:
                    view = view3
                case 4:
                    view = view4
                default:
                    fatalError()
                }
                
                if let newView = view {
                    newView.removeAllSubviews()
                    newView.addSubview(dashboardElement)
                    dashboardElement.snp.makeConstraints { make in
                        make.edges.equalTo(newView)
                    }
                }
            }
        }
    }
    
    override func handlePortraitLayout() {
        mainStackView.axis = .vertical
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(mainStackView)
        }
    }
    
    override func handleLandscapeLayout() {
        mainStackView.axis = .horizontal
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(mainStackView)
        }
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    private lazy var mainStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var view0: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.red
        
        return view
    }()
    
    private lazy var view1: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.blue
        
        return view
    }()
    
    private lazy var view2: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.yellow
        
        return view
    }()
    
    private lazy var view3: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.green
        
        return view
    }()
    
    private lazy var view4: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.orange
        
        return view
    }()
    
    private lazy var buttonView: UIView! = {
        let buttonView = UIView()
        buttonView.backgroundColor = Colors.colorPrimary
        
        return buttonView
    }()
    
    private lazy var btnPlayPause: UIButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        
        return button
    }()
    
}
