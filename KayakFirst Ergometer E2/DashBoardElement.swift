//
//  DashBoardElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashBoardElement: CustomUi {
    
    private var labelTitle: UILabel?
    internal var labelValue: UILabel?
    
    override func initUi(superview: UIView) {
        let verticalStackLayout = UIStackView(frame: superview.frame)
        verticalStackLayout.axis = .vertical
        verticalStackLayout.distribution = .fillProportionally
        verticalStackLayout.addArrangedSubview(initTitleLabel())
        verticalStackLayout.addArrangedSubview(initValueLabel())
        
        superview.addSubview(verticalStackLayout)
        
        setTitle()
    }
    
    private func initTitleLabel() -> UIView {
        labelTitle = UILabel()
        labelTitle!.textAlignment = .center
        labelTitle!.text = getTitle()
        
        return labelTitle!
    }
    
    private func initValueLabel() -> UIView {
        labelValue = UILabel()
        labelValue!.textAlignment = .center
        
        return labelValue!
    }
    
    public func refresh() {
        labelValue?.text = getFormattedText()
    }
    
    private func setTitle() {
        labelTitle?.text = getTitle()
    }
    
    //MARK: abstract functions
    internal func getStringFormatter() -> TimeEnum {
        return TimeEnum.timeFormatThree
    }
    
    internal func getFormattedText() -> String {
        return ""
    }
    
    internal func getValue() -> Double {
        return 0.0
    }
    
    internal func getTitle() -> String {
        return ""
    }
}
