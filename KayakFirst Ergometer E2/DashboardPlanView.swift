//
//  DashboardPlanView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardPlanView: UIView {
    
    //MARK: constants
    private let progressHeight: CGFloat = 10
    private let valueFontSize: CGFloat = 60
    
    //MARK: properties
    var plan: Plan? {
        didSet {
            peTableView.dataList = self.plan?.planElements
        }
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init views
    private func initView() {
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
        let deDivider = DividerView()
        deElementStackView.addArrangedSubview(deDivider)
        deElementStackView.addArrangedSubview(deSpm)
        
        mainStackView.addArrangedSubview(deElementStackView)
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        progressViewComplete.snp.makeConstraints { (make) in
            make.height.equalTo(progressHeight)
        }
        progressViewPlanElement.snp.makeConstraints { (make) in
            make.height.equalTo(progressViewComplete)
        }
        valuesStackView.snp.makeConstraints { (make) in
            make.height.equalTo(deElementStackView)
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
            make.height.equalTo(115)
        }
        
        
        backgroundColor = Colors.colorPrimary
    }
    
    //MARK: views
    private lazy var progressViewComplete: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorAccent
        
        progressView.progress = 0.7
        
        return progressView
    }()
    
    private lazy var progressViewPlanElement: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorPlanLight
        
        progressView.progress = 0.3
        
        return progressView
    }()
    
    private lazy var labelValue: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
        label.text = "88:88"
        
        return label
    }()
    
    private lazy var labelValueAccent: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
        label.text = "1236 m"
        
        return label
    }()
    
    private lazy var deActual1000: DashBoardElement_Actual1000! = {
        let de = DashBoardElement_Actual1000()
        
        return de
    }()
    
    private lazy var deSpm: DashBoardElement_Strokes! = {
        let de = DashBoardElement_Strokes()
        
        return de
    }()
    
    private lazy var tableView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.peTableView)
        self.peTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        view.addSubview(self.viewGrad)
        self.viewGrad.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(100)
        }
        
        return view
    }()
    
    private lazy var peTableView: PEDashboardTableView! = {
        let tableView = PEDashboardTableView(view: self)
        
        return tableView
    }()
    
    private lazy var viewGrad: UIView! = {
        let view = UIView()
        
        view.backgroundColor = Colors.colorTransparent
        
        //TODO: gradient
        view.applyGradient(withColours: [Colors.colorAccent, Colors.colorGreen], gradientOrientation: GradientOrientation.topRightBottomLeft)
        
        return view
    }()
    
}
