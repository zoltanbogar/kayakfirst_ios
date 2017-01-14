//
//  StartDelayView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class StartDelayView: CustomUi {
    
    override func initUi(superview: UIView) {
        superview.backgroundColor = Colors.startDelayBackground
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height))
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        initTitleLabel(view: stackView)
        initValueLabel(view: stackView)
        initBtnQuickStart(view: stackView)
        
        superview.addSubview(stackView)
    }
    
    private func initTitleLabel(view: UIStackView) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        titleLabel.text = try!getString("delay_start_seconds")
        titleLabel.textColor = Colors.colorWhite
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(50)
        titleLabel.adjustsFontSizeToFitWidth = true
        view.addArrangedSubview(titleLabel)
    }
    
    private func initValueLabel(view: UIStackView) {
        let valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        valueLabel.text = "0"
        valueLabel.textColor = Colors.colorWhite
        valueLabel.textAlignment = .center
        valueLabel.font = valueLabel.font.withSize(200)
        valueLabel.adjustsFontSizeToFitWidth = true
        view.addArrangedSubview(valueLabel)
    }
    
    private func initBtnQuickStart(view: UIStackView) {
        let btnQuickStart = getKayakButton(
            width: view.frame.width,
            height: 100,
            text: try! getString("delay_quick_start"),
            backgroundColor: Colors.colorWhite,
            textColor: Colors.colorAccent)
            
        view.addArrangedSubview(btnQuickStart)
    }
    
}
