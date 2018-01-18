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

let logoHeader = UIImage(named: "logo_header")?.withRenderingMode(.alwaysOriginal)

//MARK: protocol
protocol BaseVcProtocol {
    func onResume()
    func onPause()
}

class BaseVC<E: BaseLayout>: UIViewController, BaseVcProtocol {
    
    //MARK: properties
    let contentView = UIView()
    private var viewInited = false
    private var progressView: ProgressView?
    var contentLayout: E?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        
        initViewEdges()
        initView()
        viewInited = true
        
        view.backgroundColor = Colors.colorPrimary
        
        initProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTabBarItems()
        
        onResume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onPause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        handleScreenOrientation(size: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        handleScreenOrientation(size: size)
    }
    
    func onResume() {
        //override if needed
    }
    
    func onPause() {
        //override if needed
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
    
    func showCloseButton() {
        self.navigationItem.setLeftBarButtonItems([btnClose], animated: true)
    }
    
    func removeCloseButton() {
        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
    }
    
    func showCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let button = UIBarButtonItem()
        button.image = UIImage(named: "arrowBack")
        button.target = self
        button.action = #selector(backClick(sender:))
        
        self.navigationItem.leftBarButtonItem = button
    }
    
    func backClick(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private lazy var logoBarItem: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "logo_header")
        
        return button
    }()
    
    //MARK: tabbarItems
    private lazy var btnClose: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_clear_white_24dp")
        button.target = self
        button.action = #selector(btnCloseClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc func btnCloseClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initViewEdges() {
        contentView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view).inset(UIEdgeInsetsMake(0, 0, getTabBarHeight(viewController: self), 0))
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
        }
    }
    
    private func initProgressView() {
        progressView = ProgressView(superView: view)
    }
    
    func showProgress(baseManagerType: BaseManagerType?) {
        if let managerType = baseManagerType {
            showProgress(isShow: managerType.isProgressShown())
        }
    }
    
    func showProgress(isShow: Bool) {
        progressView?.show(isShow)
    }
    
    func dismissProgress() {
        progressView?.show(false)
    }
    
    func showToast(text: String) {
        AppToast<E>(baseVc: self, text: text).show()
    }
    
    func handleScreenOrientation(size: CGSize) {
        if viewInited {
            if isScreenPortrait(size: size) {
                handlePortraitLayout(size: size)
            } else {
                handleLandscapeLayout(size: size)
            }
        }
    }
    
    func getTopMargin() -> CGFloat {
        return getNavigationBarHeight(viewController: self)
    }
    
    func handlePortraitLayout(size: CGSize) {
        self.contentLayout?.handlePortraitLayout(size: size)
    }
    
    func handleLandscapeLayout(size: CGSize) {
        self.contentLayout?.handleLandscapeLayout(size: size)
    }
    
    func initView() {
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
    }
    
    //MARK: abstract functions
    func getContentLayout(contentView: UIView) -> E {
        fatalError("Must be implemented")
    }
}
