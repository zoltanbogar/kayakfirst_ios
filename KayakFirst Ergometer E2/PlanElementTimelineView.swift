//
//  PlanElementTimelineView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanElementTimelineView: UIView {
    
    //MARK: properties
    private let weight: CGFloat
    
    //MARK: init
    init(weight: CGFloat) {
        self.weight = weight
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: weight * 100, height:  timeLineHeight)
        }
    }
    
}
