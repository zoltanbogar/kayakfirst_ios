//
//  VcWelcomeLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcWelcomeLayout: BaseLayout {
    
    //MARK: constants
    private let segmentItems = [getString("user_login"), getString("user_register")]
    private let marginHorizontal: CGFloat = 30
    
    //MARK: properties
    private let loginRegisterView = UIView()
    private let viewController: WelcomeViewController
    
    init(contentView: UIView, viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init(contentView: contentView)
    }
    
    func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 1:
            viewSub = registerView
        default:
            viewSub = loginView
        }
        
        loginRegisterView.removeAllSubviews()
        loginRegisterView.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(loginRegisterView)
        }
    }
    
    override func setView() {
        contentView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
            make.width.equalTo(contentView).inset(UIEdgeInsetsMake(0, marginHorizontal, 0, marginHorizontal))
            make.centerX.equalTo(contentView)
        }
        loginRegisterView.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.edges.equalTo(loginRegisterView)
        }
        contentView.addSubview(loginRegisterView)
        loginRegisterView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(margin)
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, marginHorizontal, 0, 0))
            make.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, marginHorizontal))
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
    }
    
    //MARK: views
    lazy var segmentedControl: UISegmentedControl! = {
        let control = UISegmentedControl(items: self.segmentItems)
        control.tintColor = Colors.colorAccent
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    lazy var loginView: LoginView! = {
        let view = LoginView(viewController: self.viewController)
        
        return view
    }()
    
    lazy var registerView: RegisterView! = {
        let view = RegisterView(viewController: self.viewController)
        
        return view
    }()
    
}
