//
//  ViewDashboardPlanLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewDashboardPlanLayout: BaseLayout {
    
    //MARK: constants
    private let progressHeight: CGFloat = 12
    private let valueFontSize: CGFloat = 70
    
    //MARK: properties
    private let tableStackView = UIStackView()
    
    override func setView() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        
        mainStackView.addArrangedSubview(progressViewComplete)
        
        let valuesStackView = UIStackView()
        valuesStackView.axis = .horizontal
        valuesStackView.distribution = .fillEqually
        valuesStackView.addArrangedSubview(labelValue)
        valuesStackView.addArrangedSubview(labelValueAccent)
        
        mainStackView.addArrangedSubview(valuesStackView)
        
        mainStackView.addArrangedSubview(progressViewPlanElement)
        
        mainStackView.addArrangedSubview(tableStackView)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        progressViewComplete.snp.makeConstraints { (make) in
            make.height.equalTo(progressHeight)
        }
        progressViewPlanElement.snp.makeConstraints { (make) in
            make.height.equalTo(progressViewComplete)
        }
        
        tableStackView.snp.makeConstraints { (make) in
            make.width.equalTo(contentView)
            make.top.equalTo(progressViewPlanElement.snp.bottom)
            make.bottom.equalTo(contentView)
        }
        
        handlePortraitLayout(size: CGSize.zero)
        
        contentView.backgroundColor = Colors.colorPrimary
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        
        tableStackView.axis = .vertical
        tableStackView.removeAllSubviews()
        
        let spaceView = UIView()
        spaceView.backgroundColor = Colors.colorTransparent
        tableStackView.addArrangedSubview(spaceView)
        
        spaceView.snp.makeConstraints { (make) in
            make.height.equalTo(margin)
        }
        
        tableStackView.addArrangedSubview(tableView)
        
        let horizontalDivider = DividerView()
        tableStackView.addArrangedSubview(horizontalDivider)
        horizontalDivider.snp.makeConstraints { (make) in
            make.height.equalTo(dashboardDividerWidth)
        }
        
        let deElementStackView = UIStackView()
        deElementStackView.axis = .horizontal
        deElementStackView.addArrangedSubview(deActual1000)
        let deDivider = HalfDivider()
        deElementStackView.addArrangedSubview(deDivider)
        deElementStackView.addArrangedSubview(deSpm)
        
        tableStackView.addArrangedSubview(deElementStackView)
        
        deActual1000.snp.removeConstraints()
        deActual1000.snp.makeConstraints { (make) in
            make.width.equalTo(deSpm)
        }
        deDivider.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
            make.left.equalTo(deActual1000.snp.right)
        }
        deElementStackView.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        
        let width = contentView.frame.width
        
        tableStackView.axis = .horizontal
        tableStackView.removeAllSubviews()
        
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        
        let spaceView = UIView()
        spaceView.backgroundColor = Colors.colorTransparent
        leftStackView.addArrangedSubview(spaceView)
        
        spaceView.snp.makeConstraints { (make) in
            make.height.equalTo(margin)
        }
        
        leftStackView.addArrangedSubview(tableView)
        
        tableStackView.addArrangedSubview(leftStackView)
        
        let verticalDivider = DividerView()
        tableStackView.addArrangedSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
            make.height.equalToSuperview()
        }
        
        let deElementStackView = UIStackView()
        deElementStackView.axis = .vertical
        deElementStackView.addArrangedSubview(deActual1000)
        let deDivider = DividerView()
        deElementStackView.addArrangedSubview(deDivider)
        deElementStackView.addArrangedSubview(deSpm)
        
        tableStackView.addArrangedSubview(deElementStackView)
        
        leftStackView.snp.makeConstraints { (make) in
            make.width.equalTo(width * 2 / 3)
        }
        
        deActual1000.snp.removeConstraints()
        deActual1000.snp.makeConstraints { (make) in
            make.height.equalTo(deSpm)
        }
        deDivider.snp.makeConstraints { (make) in
            make.height.equalTo(dashboardDividerWidth)
            make.left.equalTo(deActual1000).offset(margin)
            make.right.equalToSuperview().offset(-margin)
        }
        deElementStackView.snp.makeConstraints { (make) in
            make.width.equalTo(width / 3)
        }
    }
    
    //MARK: views
    lazy var progressViewComplete: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorAccent
        
        return progressView
    }()
    
    lazy var progressViewPlanElement: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorPlanLight
        
        return progressView
    }()
    
    lazy var labelValue: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
        //TODO: delete this
        label.text = "0"
        
        return label
    }()
    
    lazy var labelValueAccent: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
        //TODO: delete this
        label.text = "0"
        
        return label
    }()
    
    lazy var deActual1000: DashBoardElement_Actual1000! = {
        let de = DashBoardElement_Actual1000()
        de.isValueVisible = true
        
        return de
    }()
    
    lazy var deSpm: DashBoardElement_Strokes! = {
        let de = DashBoardElement_Strokes()
        de.isValueVisible = true
        
        return de
    }()
    
    lazy var tableView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.peTableView)
        self.peTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        view.addSubview(self.viewGrad)
        self.viewGrad.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var peTableView: PEDashboardTableView! = {
        let tableView = PEDashboardTableView(view: self.contentView)
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    lazy var viewGrad: UIView! = {
        let view = UIView()
        
        return view
    }()
    
}
