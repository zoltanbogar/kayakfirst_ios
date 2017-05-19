//
//  KeyboardNumView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol OnKeyboardClickedListener {
    func onClicked(value: Int)
}

class KeyboardNumView: UIView {
    
    //MARK: constants
    static let valueBackSpace = -1
    static let valueNext = -2
    
    //MARK: properties
    var createPlanViewController: CreatePlanViewController?
    var keyboardClickListener: OnKeyboardClickedListener?
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        backgroundColor = Colors.colorDashBoardDivider
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = dashboardDividerWidth
        
        let horizontalSv1 = UIStackView()
        horizontalSv1.axis = .horizontal
        horizontalSv1.distribution = .fillEqually
        horizontalSv1.spacing = dashboardDividerWidth
        horizontalSv1.addArrangedSubview(btn1)
        horizontalSv1.addArrangedSubview(btn2)
        horizontalSv1.addArrangedSubview(btn3)
        
        let horizontalSv2 = UIStackView()
        horizontalSv2.axis = .horizontal
        horizontalSv2.distribution = .fillEqually
        horizontalSv2.spacing = dashboardDividerWidth
        horizontalSv2.addArrangedSubview(btn4)
        horizontalSv2.addArrangedSubview(btn5)
        horizontalSv2.addArrangedSubview(btn6)
        
        let horizontalSv3 = UIStackView()
        horizontalSv3.axis = .horizontal
        horizontalSv3.distribution = .fillEqually
        horizontalSv3.spacing = dashboardDividerWidth
        horizontalSv3.addArrangedSubview(btn7)
        horizontalSv3.addArrangedSubview(btn8)
        horizontalSv3.addArrangedSubview(btn9)
        
        let horizontalSv4 = UIStackView()
        horizontalSv4.axis = .horizontal
        horizontalSv4.distribution = .fillEqually
        horizontalSv4.spacing = dashboardDividerWidth
        horizontalSv4.addArrangedSubview(btnBackSpace)
        horizontalSv4.addArrangedSubview(btn0)
        horizontalSv4.addArrangedSubview(btnNext)
        
        verticalStackView.addArrangedSubview(horizontalSv1)
        verticalStackView.addArrangedSubview(horizontalSv2)
        verticalStackView.addArrangedSubview(horizontalSv3)
        verticalStackView.addArrangedSubview(horizontalSv4)
        
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        showAppBorder()
    }
    
    //MARK: views
    private lazy var btn1: UIButton! = {
        return self.getButton(title: "1", listener: "btn1Click")
    }()
    
    private lazy var btn2: UIButton! = {
        return self.getButton(title: "2", listener: "btn2Click")
    }()
    
    private lazy var btn3: UIButton! = {
        return self.getButton(title: "3", listener: "btn3Click")
    }()
    
    private lazy var btn4: UIButton! = {
        return self.getButton(title: "4", listener: "btn4Click")
    }()
    
    private lazy var btn5: UIButton! = {
        return self.getButton(title: "5", listener: "btn5Click")
    }()
    
    private lazy var btn6: UIButton! = {
        return self.getButton(title: "6", listener: "btn6Click")
    }()
    
    private lazy var btn7: UIButton! = {
        return self.getButton(title: "7", listener: "btn7Click")
    }()
    
    private lazy var btn8: UIButton! = {
        return self.getButton(title: "8", listener: "btn8Click")
    }()
    
    private lazy var btn9: UIButton! = {
        return self.getButton(title: "9", listener: "btn9Click")
    }()
    
    private lazy var btnBackSpace: UIButton! = {
        let button = self.getButton(title: "", listener: "btnBackSpaceClick")
        button.setImage(UIImage(named: "ic_backspace"), for: .normal)
        
        return button
    }()
    
    private lazy var btn0: UIButton! = {
        return self.getButton(title: "0", listener: "btn0Click")
    }()
    
    private lazy var btnNext: UIButton! = {
        return self.getButton(title: getString("other_next").capitalized, listener: "btnNextClick")
    }()
    
    private func getButton(title: String, listener: String) -> UIButton {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: Selector(listener), for: .touchUpInside)
        
        button.setTitleColor(Colors.colorWhite, for: .normal)
        button.backgroundColor = UIColor.white
        
        button.titleLabel?.font = UIFont(name: "BebasNeue", size: 40)
        
        return button
    }
    
    //MARK: button listeners
    private func onClicked(value: Int) {
        if let vc = createPlanViewController {
            let focusedEt = vc.activeTextView
            
            if let focusedEditText = focusedEt {
                let previousText = focusedEditText.text
                var newText = previousText
                
                if value >= 0 {
                    newText = previousText! + String(value)
                } else if value == KeyboardNumView.valueBackSpace {
                    if (previousText?.characters.count)! > 0 {
                        let endIndex = previousText!.index(previousText!.startIndex, offsetBy: (previousText!.characters.count - 1))
                        newText = previousText?.substring(to: endIndex)
                    }
                }
                focusedEditText.text = newText
            }
        }
        if let listener = keyboardClickListener {
            listener.onClicked(value: value)
        }
    }
    
    func btn1Click() {
        onClicked(value: 1)
    }
    
    func btn2Click() {
        onClicked(value: 2)
    }
    
    func btn3Click() {
        onClicked(value: 3)
    }
    
    func btn4Click() {
        onClicked(value: 4)
    }
    
    func btn5Click() {
        onClicked(value: 5)
    }
    
    func btn6Click() {
        onClicked(value: 6)
    }
    
    func btn7Click() {
        onClicked(value: 7)
    }
    
    func btn8Click() {
        onClicked(value: 8)
    }
    
    func btn9Click() {
        onClicked(value: 9)
    }
    
    func btnBackSpaceClick() {
        onClicked(value: KeyboardNumView.valueBackSpace)
    }
    
    func btn0Click() {
        onClicked(value: 0)
    }
    
    func btnNextClick() {
        onClicked(value: KeyboardNumView.valueNext)
    }
    
}
