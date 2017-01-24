//
//  KayakScrollViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 24..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class KayakScrollViewController: UIViewController {
    
    private let scrollContainer = UIView()
    private let scrollView = UIScrollView()
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollContainer)
        scrollContainer.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(scrollContainer)
            
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalTo(scrollContainer)
            make.edges.equalTo(scrollView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = containerView.bounds.size
    }
    
    
}
