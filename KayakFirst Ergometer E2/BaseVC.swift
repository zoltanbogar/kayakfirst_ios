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
        
        initViewEdges()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTabBarItems()
    }
    
    func initTabBarItems() {
        self.tabBarController?.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    //MARK: views
    private func initViewEdges() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(getTopMargin(), 0, getTabBarHeight(viewController: self), 0))
        }
    }
    
    private func getTopMargin() -> CGFloat {
        if (self.parent as? UITabBarController) != nil {
            return 0
        } else {
            return getNavigationBarHeight(viewController: self)
        }
    }
    
    //MARK: abstract functions
    func initView() {
        fatalError("Must be implemented")
    }
}
