//
//  AppScrollView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class AppScrollView: UIView, UIScrollViewDelegate {
    
    //MARK: properties
    private let view: UIView
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    //MARK: init
    init(view: UIView) {
        self.view = view
        super.init(frame: view.frame)
        scrollView.delegate = self
        
        hideScrollIndicators()
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: views
    private func initView() {
        let scrollContainer = UIView()
        view.addSubview(scrollContainer)
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalTo(view)
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
    
    override func addSubview(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    //MARK: design
    private func hideScrollIndicators() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: functions
    func scrollToView(view: UIView, animated: Bool) {
        scrollView.scrollToView(view: view, animated: animated)
    }
}
