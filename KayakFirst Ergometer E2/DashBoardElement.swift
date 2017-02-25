//
//  DashBoardElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashBoardElement: UIView {
    
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
                } else {
                    make.center.equalTo(self)
                }
            }
        }
    }
    
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
    
    public func refresh() {
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
    
    internal func getTitle() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTagInt() -> Int {
        fatalError("Must be implemented")
    }
    
    //MARK: views
    private func initView() {
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(self).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
            make.centerX.equalTo(self)
        }
        addSubview(labelValue)
        labelValue.snp.makeConstraints { make in
            make.center.equalTo(self).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
        }
        addSubview(selectedView)
        selectedView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        backgroundColor = Colors.colorPrimary
    }
    
    private lazy var labelTitle: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = self.getTitle()
        label.textColor = Colors.colorWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var labelValue: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Colors.colorWhite
        
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private lazy var selectedView: UIView! = {
        let view = UIView()
        
        view.backgroundColor = Colors.dragDropStart
        
        view.isHidden = true
        
        return view
    }()
    
    func getSnapshotView() -> UIView {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let snapshot : UIView = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    
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
