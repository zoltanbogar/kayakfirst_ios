//
//  MainViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    //TODO
    private func initView() {
        view.addSubview(btnProfile)
        btnProfile.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        view.addSubview(btnCalendar)
        btnCalendar.snp.makeConstraints { make in
            make.top.equalTo(btnProfile.snp.bottom)
            make.centerX.equalTo(view)
        }
    }
    
    private lazy var btnProfile: UIButton! = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.addTarget(self, action: #selector(btnProfileClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnCalendar: UIButton! = {
        let button = UIButton()
        button.setTitle("History", for: .normal)
        button.addTarget(self, action: #selector(btnCalendarClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func btnProfileClick() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @objc private func btnCalendarClick() {
        let vc = CalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
