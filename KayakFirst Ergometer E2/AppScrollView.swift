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
        
        log("SCROLL", "frame: \(view.frame)")
        
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor = Colors.colorWhite
        
        let horizontalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 2)] as! UIImageView)
        horizontalIndicator.backgroundColor = Colors.colorWhite
    }
    
    //MARK: functions
    func scrollToView(view: UIView, animated: Bool) {
        scrollView.scrollToView(view: view, animated: animated)
    }
    
    
    
}
