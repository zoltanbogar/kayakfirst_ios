//
//  ViewKeyboardNumLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewKeyboardNumLayout: BaseLayout {
    
    private let horizontalMargin: CGFloat = 11
    private let verticalMargin: CGFloat = 23
    
    override func setView() {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = verticalMargin
        
        let horizontalSv1 = UIStackView()
        horizontalSv1.axis = .horizontal
        horizontalSv1.distribution = .fillEqually
        horizontalSv1.spacing = horizontalMargin
        horizontalSv1.addArrangedSubview(btn1)
        horizontalSv1.addArrangedSubview(btn2)
        horizontalSv1.addArrangedSubview(btn3)
        
        let horizontalSv2 = UIStackView()
        horizontalSv2.axis = .horizontal
        horizontalSv2.distribution = .fillEqually
        horizontalSv2.spacing = horizontalMargin
        horizontalSv2.addArrangedSubview(btn4)
        horizontalSv2.addArrangedSubview(btn5)
        horizontalSv2.addArrangedSubview(btn6)
        
        let horizontalSv3 = UIStackView()
        horizontalSv3.axis = .horizontal
        horizontalSv3.distribution = .fillEqually
        horizontalSv3.spacing = horizontalMargin
        horizontalSv3.addArrangedSubview(btn7)
        horizontalSv3.addArrangedSubview(btn8)
        horizontalSv3.addArrangedSubview(btn9)
        
        let horizontalSv4 = UIStackView()
        horizontalSv4.axis = .horizontal
        horizontalSv4.distribution = .fillEqually
        horizontalSv4.spacing = horizontalMargin
        horizontalSv4.addArrangedSubview(btnBackSpace)
        horizontalSv4.addArrangedSubview(btn0)
        horizontalSv4.addArrangedSubview(btnNext)
        
        verticalStackView.addArrangedSubview(horizontalSv1)
        verticalStackView.addArrangedSubview(horizontalSv2)
        verticalStackView.addArrangedSubview(horizontalSv3)
        verticalStackView.addArrangedSubview(horizontalSv4)
        
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    //MARK: views
    lazy var btn1: UIButton! = {
        return self.getButton(title: "1")
    }()
    
    lazy var btn2: UIButton! = {
        return self.getButton(title: "2")
    }()
    
    lazy var btn3: UIButton! = {
        return self.getButton(title: "3")
    }()
    
    lazy var btn4: UIButton! = {
        return self.getButton(title: "4")
    }()
    
    lazy var btn5: UIButton! = {
        return self.getButton(title: "5")
    }()
    
    lazy var btn6: UIButton! = {
        return self.getButton(title: "6")
    }()
    
    lazy var btn7: UIButton! = {
        return self.getButton(title: "7")
    }()
    
    lazy var btn8: UIButton! = {
        return self.getButton(title: "8")
    }()
    
    lazy var btn9: UIButton! = {
        return self.getButton(title: "9")
    }()
    
    lazy var btnBackSpace: UIButton! = {
        let button = self.getButton(title: "")
        button.setImage(UIImage(named: "ic_backspace"), for: .normal)
        
        return button
    }()
    
    lazy var btn0: UIButton! = {
        return self.getButton(title: "0")
    }()
    
    lazy var btnNext: UIButton! = {
        return self.getButton(title: getString("other_ok").capitalized)
    }()
    
    private func getButton(title: String) -> UIButton {
        let button = ColorizedButton()
        
        button.setTitle(title, for: .normal)
        
        button.setTitleColor(Colors.colorWhite, for: .normal)
        button.backgroundColor = UIColor.white
        
        button.layer.cornerRadius = planRadius
        
        button.titleLabel?.font = UIFont(name: "BebasNeue", size: 50)
        
        return button
    }
    
}
