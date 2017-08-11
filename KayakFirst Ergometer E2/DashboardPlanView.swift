//
//  DashboardPlanView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardPlanView: RefreshView {
    
    //MARK: constants
    private let progressHeight: CGFloat = 12
    private let valueFontSize: CGFloat = 75
    
    private let telemetry = Telemetry.sharedInstance
    
    //MARK: properties
    var plan: Plan? {
        didSet {
            localeValue = 0
            planElementPosition = 0
            
            peTableView.dataList = self.plan?.planElements
            
            setProgressBarPlanElementColor()
        }
    }
    var isDone: Bool {
        return planElementPosition == plan?.planElements?.count
    }
    private var localeValue: Double = 0
    private var planElementPosition: Int = 0
    private let planSoundHelper = PlanSoundHelper.sharedInstance
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: functions
    func viewDidLayoutSubViews() {
        viewGrad.superview?.layer.mask = getGradient(withColours: [Colors.colorPrimary, Colors.colorTransparent], gradientOrientation: .verticalSlow)
    }
    
    override func startRefresh(_ isStart: Bool) {
        if isStart {
            super.startRefresh(true)
        }
        
        deActual1000.startRefresh(isStart)
        deSpm.startRefresh(isStart)
        
        planSoundHelper.shouldPlay = isStart
    }
    
    func stopRefresh() {
        startRefresh(false)
        
        planSoundHelper.stopSound()
        
        timer?.invalidate()
    }
    
    override func refreshUi() {
        if plan != nil && plan?.planElements != nil {
            let totalPercent = getTotalPercent()
            
            if totalPercent > 0 {
                setPlanElementPosition()
                let currentPercent = getCurrentPercent()
                
                progressViewComplete.progress = Float(totalPercent / 100)
                progressViewPlanElement.progress = (Float((Double(1) - currentPercent)))
                
                setTextsByPercent(percent: currentPercent)
            } else {
                planElementPosition = plan!.planElements!.count
                
                planSoundHelper.stopSound()
                reset()
            }
        }
    }
    
    private func setPlanElementPosition() {
        let localPlanElementPos = planElementPosition
        var sum: Double = 0
        for i in 0..<plan!.planElements!.count {
            sum += plan!.planElements![i].value
            
            if sum >= getCurrentTotalValue() {
                planElementPosition = i
                
                if localPlanElementPos != i {
                    reset()
                }
                break
            }
        }
    }
    
    private func getCurrentTotalValue() -> Double {
        var valueToCheck = telemetry.duration
        if plan!.type == PlanType.distance {
            valueToCheck = telemetry.distance
        }
        return valueToCheck
    }
    
    private func getTotalPercent() -> Double {
        if getCurrentTotalValue() > plan!.length {
            return -1
        } else {
            let percent: Double = getCurrentTotalValue() / plan!.length
            
            return (Double(100) * (Double(1) - percent))
        }
    }
    
    private func getCurrentPercent() -> Double {
        if let currentPlanElement = getCurrentPlanElement() {
            var sum: Double = 0
            for i in 0..<planElementPosition {
                sum += plan!.planElements![i].value
            }
            
            let diff = getCurrentTotalValue() - sum
            let percent = diff / currentPlanElement.value
            
            return percent
        }
        return 1
    }
    
    private func setTextsByPercent(percent: Double) {
        var valueText = getFormattedTimeText(value: 0)
        var valueAccentText = getFormattedDistanceText(value: 0)
        
        if plan!.type == PlanType.distance {
            valueText = getFormattedDistanceText(value: 0)
            valueAccentText = getFormattedTimeText(value: 0)
        }
        
        if let currentPlanElement = getCurrentPlanElement() {
            let value = (1 - percent) * currentPlanElement.value
            
            valueText = getFormattedTimeText(value: value)
            valueAccentText = getFormattedDistanceText(value: (telemetry.distance - localeValue))
            
            if plan!.type == PlanType.distance {
                valueText = getFormattedDistanceText(value: value)
                valueAccentText = getFormattedTimeText(value: (telemetry.duration - localeValue))
            }
            
            planSoundHelper.playSoundIfNeeded(value: value, planType: plan!.type)
        }
        setTexts(valueText: valueText, valueAccentText: valueAccentText)
    }
    
    private func setTexts(valueText: String, valueAccentText: String) {
        labelValue.text = valueText
        labelValueAccent.text = valueAccentText
    }
    
    private func reset() {
        localeValue = telemetry.distance
        
        if plan!.type == PlanType.distance {
            localeValue = telemetry.duration
        }
        
        setTextsByPercent(percent: 0)
        peTableView.removePlanElement(position: 0)
        
        setProgressBarPlanElementColor()
    }
    
    private func getFormattedTimeText(value: Double) -> String {
        return DateFormatHelper.getDate(dateFormat: DateFormatHelper.minSecFormat, timeIntervallSince1970: value)
    }
    
    private func getFormattedDistanceText(value: Double) -> String {
        return "" + "\(Int(value))" + " " + UnitHelper.getDistanceUnit()
    }
    
    private func getCurrentPlanElement() -> PlanElement? {
        if plan?.planElements != nil && planElementPosition < (plan?.planElements?.count)! {
            return plan?.planElements?[planElementPosition]
        }
        return nil
    }
    
    private func setProgressBarPlanElementColor() {
        var color = Colors.colorAccent
        
        if let currentPlanElement = getCurrentPlanElement() {
            color = getPlanElementColor(planElement: currentPlanElement)
        }
        
        progressViewPlanElement.trackTintColor = color
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
        let deDivider = HalfDivider()
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
        
        backgroundColor = Colors.colorPrimary
    }
    
    //MARK: views
    private lazy var progressViewComplete: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorAccent
        
        return progressView
    }()
    
    private lazy var progressViewPlanElement: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorPlanLight
        
        return progressView
    }()
    
    private lazy var labelValue: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
        return label
    }()
    
    private lazy var labelValueAccent: UILabel! = {
        let label = BebasUILabel()
        
        label.textAlignment = .center
        label.font = label.font.withSize(self.valueFontSize)
        
        return label
    }()
    
    private lazy var deActual1000: DashBoardElement_Actual1000! = {
        let de = DashBoardElement_Actual1000()
        de.isValueVisible = true
        
        return de
    }()
    
    private lazy var deSpm: DashBoardElement_Strokes! = {
        let de = DashBoardElement_Strokes()
        de.isValueVisible = true
        
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
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var peTableView: PEDashboardTableView! = {
        let tableView = PEDashboardTableView(view: self)
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    private lazy var viewGrad: UIView! = {
        let view = UIView()
        
        return view
    }()
    
}
