//
//  SetDashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SetDashboardVc: BaseVC {
    
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
        
        view.backgroundColor = Colors.colorBluetooth
        
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
