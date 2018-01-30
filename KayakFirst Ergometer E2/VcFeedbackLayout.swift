//
//  VcFeedbackLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 22..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import ActiveLabel

class VcFeedbackLayout: BaseLayout {
    
    override func setView() {
        let view = UIView()
        view.addSubview(labelInfo)
        view.addSubview(labelInfoDetails)
        view.addSubview(tvFeedback)
        
        let dividerView = UIView()
        dividerView.backgroundColor = Colors.colorAccent
        
        view.addSubview(dividerView)
        
        labelInfo.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        labelInfoDetails.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(labelInfo.snp.bottom).offset(margin05)
        }
        tvFeedback.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(labelInfoDetails.snp.bottom).offset(margin)
        }
        dividerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(dashboardDividerWidth)
            make.top.equalTo(tvFeedback.snp.bottom)
        }
        
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.top.equalToSuperview().offset(margin)
            make.bottom.equalToSuperview().offset(margin)
        }
    }
    
    //MARK: view
    lazy var labelInfo: ActiveLabel! = {
        let label = ActiveLabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var labelInfoDetails: UILabel! = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.text = getString("feedback_info_message")
        
        return label
    }()
    
    lazy var tvFeedback: TextViewWithHint! = {
        let textView = TextViewWithHint()
        
        textView.hint = getString("feedback_hint")
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        
        textView.backgroundColor = Colors.colorTransparent
        textView.font = .systemFont(ofSize: 16)
        
        return textView
    }()
    
    //MARK: tabbar items
    lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")?.withRenderingMode(.alwaysOriginal)
        
        return button
    }()
    
}
