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
        
        let spaceView = UIView()
        spaceView.backgroundColor = Colors.colorTransparent
        mainStackView.addArrangedSubview(spaceView)
        
        mainStackView.addArrangedSubview(tableView)
        
        let horizontalDivider = DividerView()
        mainStackView.addArrangedSubview(horizontalDivider)
        horizontalDivider.snp.makeConstraints { (make) in
            make.height.equalTo(dashboardDividerWidth)
        }
        
        let deElementStackView = UIStackView()
        deElementStackView.axis = .horizontal
        deElementStackView.addArrangedSubview(deActual1000)
        let deDivider = HalfDivider()
        deElementStackView.addArrangedSubview(deDivider)
        deElementStackView.addArrangedSubview(deSpm)
        
        mainStackView.addArrangedSubview(deElementStackView)
        
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
        spaceView.snp.makeConstraints { (make) in
            make.height.equalTo(margin)
        }
        deActual1000.snp.makeConstraints { (make) in
            make.width.equalTo(deSpm)
        }
        deDivider.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
        }
        deElementStackView.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
        
        contentView.backgroundColor = Colors.colorPrimary
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
        
        return label
    }()
    
    lazy var labelValueAccent: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
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
