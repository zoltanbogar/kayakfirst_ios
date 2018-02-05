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
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(labelInfo)
        stackView.addVerticalSpacing(spacing: margin05)
        stackView.addArrangedSubview(labelInfoDetails)
        stackView.addVerticalSpacing(spacing: margin)
        stackView.addArrangedSubview(tvFeedback)
        
        let dividerView = UIView()
        dividerView.backgroundColor = Colors.colorAccent
        
        stackView.addArrangedSubview(dividerView)
        
        dividerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(dashboardDividerWidth)
        }
        
        let scrollView = AppScrollView(view: contentView)
        scrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.top.equalToSuperview().offset(margin)
            make.bottom.equalToSuperview().offset(-margin)
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
        button.title = getString("other_send")
        
        return button
    }()
    
}
