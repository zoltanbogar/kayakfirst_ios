//
//  BaseMainTabVC.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func showLogoLeft(viewController: UIViewController) {
    var navItems = viewController.navigationItem.leftBarButtonItems
    if navItems != nil {
        if !(navItems?.contains(logoBarItem))! {
            navItems!.append(logoBarItem)
        }
    } else {
        navItems = [logoBarItem]
    }
    viewController.navigationItem.setLeftBarButtonItems(navItems, animated: true)
}

func showLogoRight(viewController: UIViewController) {
    var navItems = viewController.navigationItem.rightBarButtonItems
    if navItems != nil {
        if !(navItems?.contains(logoBarItem))! {
            navItems!.insert(logoBarItem, at: 0)
        }
    } else {
        navItems = [logoBarItem]
    }
    viewController.navigationItem.setRightBarButtonItems(navItems, animated: true)
}

func showLogoCenter(viewController: UIViewController) {
    let imageView = UIImageView(image: logoHeader)
    viewController.navigationItem.titleView = imageView
}

let logoBarItem: UIBarButtonItem! = {
    let button = UIBarButtonItem()
    button.image = logoHeader
    
    return button
}()

let logoHeader = UIImage(named: "logo_header")

class BaseVC: UIViewController {
    
    //MARK: properties
    let contentView = UIView()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        
        initViewEdges()
        initView()
        
        view.backgroundColor = Colors.colorPrimary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTabBarItems()
        
        handleScreenOrientation(size: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        handleScreenOrientation(size: size)
    }
    
    func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    //MARK: views
    func showLogoOnLeft() {
        showLogoLeft(viewController: self)
    }
    
    func showLogoOnRight() {
        showLogoRight(viewController: self)
    }
    
    private lazy var logoBarItem: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "logo_header")
        
        return button
    }()
    
    private func initViewEdges() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(getTopMargin(), 0, getTabBarHeight(viewController: self), 0))
        }
    }
    
    func handleScreenOrientation(size: CGSize) {
        contentView.removeAllSubviews()
        initView()
        if isScreenPortrait(size: size) {
            handlePortraitLayout(size: size)
        } else {
            handleLandscapeLayout(size: size)
        }
    }
    
    func getTopMargin() -> CGFloat {
        return getNavigationBarHeight(viewController: self)
    }
    
    func handlePortraitLayout(size: CGSize) {
        //override if needed
    }
    
    func handleLandscapeLayout(size: CGSize) {
        //override if needed
    }
    
    //MARK: abstract functions
    func initView() {
        fatalError("Must be implemented")
    }
}
