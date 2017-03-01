//
//  BaseMainTabVC.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

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
    private func initViewEdges() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(getTopMargin(), 0, getTabBarHeight(viewController: self), 0))
        }
    }
    
    func handleScreenOrientation(size: CGSize) {
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
