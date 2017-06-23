//
//  DashBoardElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashBoardElement: UIView {
    
    //MARK: constants
    private let refreshMillis: Double = 33
    
    //MARK: properties
    internal let telemetry = Telemetry.sharedInstance
    var isSelected: Bool = false {
        didSet {
            selectedView.isHidden = !isSelected
        }
    }
    var isValueVisible: Bool = true {
        didSet {
            labelValue.isHidden = !isValueVisible
            labelTitle.snp.makeConstraints { make in
                if isValueVisible {
                    make.top.equalTo(self).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
                    make.centerX.equalTo(self)
                    
                    if isMetric() {
                        labelTitle.text = self.getTitleOneLineMetric().uppercased()
                    } else {
                        labelTitle.text = self.getTitleOneLineImperial().uppercased()
                    }
                } else {
                    make.center.equalTo(self)
                    
                    if isMetric() {
                        labelTitle.text = self.getTitleMetric().uppercased()
                    } else {
                        labelTitle.text = self.getTitleImperial().uppercased()
                    }
                }
            }
        }
    }
    var isLandscape: Bool = false {
        didSet {
            if isLandscape {
                initLandscape()
            } else {
                initPortrait()
            }
        }
    }
    private var timer: Timer?
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
        tag = getTagInt()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRefresh(_ isStart: Bool) {
        if isStart {
            timer = Timer.scheduledTimer(timeInterval: (refreshMillis / 1000), target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    @objc private func refresh() {
        labelValue?.text = getFormattedText()
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            let height: CGFloat = 100
            return CGSize(width: 0, height: height)
        }
    }

    //MARK: abstract functions
    internal func getStringFormatter() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getFormattedText() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getValue() -> Double {
        fatalError("Must be implemented")
    }
    
    internal func getTitleMetric() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTitleImperial() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTitleOneLineMetric() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTitleOneLineImperial() -> String {
        fatalError("Must be implemented")
    }
    
    internal func isMetric() -> Bool {
        fatalError("Must be implemented")
    }
    
    internal func getTagInt() -> Int {
        fatalError("Must be implemented")
    }
    
    //MARK: views
    private func initView() {
        addSubview(labelTitle)
        addSubview(labelValue)
        addSubview(selectedView)
        selectedView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        backgroundColor = Colors.colorPrimary
        initPortrait()
    }
    
    private func initLandscape() {
        labelTitle.snp.removeConstraints()
        labelValue.snp.removeConstraints()
        labelTitle.snp.makeConstraints { make in
            make.left.equalTo(self).inset(UIEdgeInsetsMake(0, margin05, 0, 0))
            make.centerY.equalTo(self)
            make.height.equalTo(self)
        }
        
        labelValue.snp.makeConstraints { make in
            make.left.equalTo(labelTitle.snp.right)
            make.center.equalTo(self).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.height.equalTo(self)
        }
    }
    
    private func initPortrait() {
        labelTitle.snp.removeConstraints()
        labelValue.snp.removeConstraints()
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(self).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
            make.centerX.equalTo(self)
            make.height.equalTo(60)
        }
        
        labelValue.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom)
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    private lazy var labelTitle: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        if self.isMetric() {
            label.text = self.getTitleMetric().uppercased()
        } else {
            label.text = self.getTitleImperial().uppercased()
        }
        label.textColor = Colors.colorWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var labelValue: UILabel! = {
        let label = LabelWithAdaptiveTextHeight()
        label.textAlignment = .center
        label.textColor = Colors.colorWhite
        
        label.font = UIFont(name: "BebasNeue", size: 94)
        
        return label
    }()
    
    private lazy var selectedView: UIView! = {
        let view = UIView()
        
        view.backgroundColor = Colors.dragDropStart
        
        view.isHidden = true
        
        return view
    }()
    
    class func getDashBoardElementByTag(tag: Int, isValueVisible: Bool) -> DashBoardElement {
        var dashBoardelement: DashBoardElement
        
        switch tag {
        case DashBoardElement_Actual200.tagInt:
            dashBoardelement = DashBoardElement_Actual200()
        case DashBoardElement_Actual500.tagInt:
            dashBoardelement = DashBoardElement_Actual500()
        case DashBoardElement_Actual1000.tagInt:
            dashBoardelement = DashBoardElement_Actual1000()
        case DashBoardElement_Av200.tagInt:
            dashBoardelement = DashBoardElement_Av200()
        case DashBoardElement_Av500.tagInt:
            dashBoardelement = DashBoardElement_Av500()
        case DashBoardElement_Av1000.tagInt:
            dashBoardelement = DashBoardElement_Av1000()
        case DashBoardElement_AvPullForce.tagInt:
            dashBoardelement = DashBoardElement_AvPullForce()
        case DashBoardElement_AvSpeed.tagInt:
            dashBoardelement = DashBoardElement_AvSpeed()
        case DashBoardElement_AvStrokes.tagInt:
            dashBoardelement = DashBoardElement_AvStrokes()
        case DashBoardElement_CurrentSpeed.tagInt:
            dashBoardelement = DashBoardElement_CurrentSpeed()
        case DashBoardElement_Distance.tagInt:
            dashBoardelement = DashBoardElement_Distance()
        case DashBoardElement_Duration.tagInt:
            dashBoardelement = DashBoardElement_Duration()
        case DashBoardElement_PullForce.tagInt:
            dashBoardelement = DashBoardElement_PullForce()
        case DashBoardElement_Strokes.tagInt:
            dashBoardelement = DashBoardElement_Strokes()
        default:
            fatalError("Error in dashBoardelement tag")
        }
        dashBoardelement.isValueVisible = isValueVisible
        
        return dashBoardelement
    }
}
