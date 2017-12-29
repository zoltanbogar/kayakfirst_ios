//
//  AppToast.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AppToast: UIView {
    
    //MARK: constants
    private let lengthShort: Double = 3 //3 sec
    private let animationTime: Double = 0.4
    
    //MARK: properties
    private let baseVc: BaseVC<BaseLayout>
    private let text: String
    
    //MARK: init
    init(baseVc: BaseVC<BaseLayout>, text: String) {
        self.baseVc = baseVc
        self.text = text
        
        super.init(frame: CGRect.zero)
        
        initView()
        
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: functions
    func show() {
        isHidden = false
        self.alpha = 0.0
        
        UIView.animate(withDuration: animationTime, animations: {
            self.alpha = 1.0
        })
        
        Timer.scheduledTimer(timeInterval: lengthShort, target: self, selector: #selector(dismissToast), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissToast() {
        UIView.animate(withDuration: animationTime, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.isHidden = true
        })
    }
    
    //MARK: init view
    private func initView() {
        backgroundColor = Colors.colorAccent
        layer.cornerRadius = 15
        
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(margin05, margin05, margin05, margin05))
        }
        
        baseVc.contentView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-margin05)
            make.left.lessThanOrEqualToSuperview().offset(margin2)
            make.right.lessThanOrEqualToSuperview().offset(-margin2)
            make.centerX.equalToSuperview()
        }
    }
    
    private lazy var label: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        label.text = self.text
        
        return label
    }()
    
}
