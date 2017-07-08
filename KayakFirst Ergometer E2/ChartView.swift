//
//  ChartView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import Charts

//MARK: time enum
enum ChartMode: String {
    case chartModeTime = "time"
    case chartModeDistance = "distance"
}

class ChartView: UIView {
    
    //MARK: properties
    private var position: Int?
    private var lineChartData: AppLineChartData?
    private var diagramLabelList: [DiagramLabel]?
    private var chartMode: ChartMode?
    
    //MARK: init
    init(position: Int, chartMode: ChartMode) {
        super.init(frame: CGRect.zero)
        
        self.chartMode = chartMode
        self.position = position
        
        initView()
        disableLabelIfNeeded()
        initLabelList()
        initChart()
        initPlanTimeLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLabelList() {
        diagramLabelList = [labelT200, labelT500, labelT1000, labelStrokes, labelForce, labelSpeed]
    }
    
    private func initChart() {
        if chartMode! == ChartMode.chartModeDistance {
            lineChartData = LineChartDistance(lineChart: lineChart, distanceList: TrainingManager.sharedInstance.detailsTrainingList![position!].distanceList, position: position!)
        } else {
            lineChartData = LineChartTime(lineChart: lineChart, position: position!)
        }
        refreshChart()
    }
    
    private func refreshChart() {
        lineChartData?.createTrainingListByLabel(diagramLabels: diagramLabelList!)
    }
    
    private func disableLabelIfNeeded() {
        let isOutdoor = TrainingManager.sharedInstance.detailsTrainingList![position!].trainingEnvironmentType == TrainingEnvironmentType.outdoor
        
        if isOutdoor {
            labelForce.isDisabled = true
        }
    }
    
    //TODO
    private func initPlanTimeLine() {
        let sumTrainings = TrainingManager.sharedInstance.detailsTrainingList
        
        let plan = sumTrainings?[position!].planTraining
        
        planView.isHidden = true
        
        if plan != nil && isModeCorrect(plan: plan!) {
            planView.isHidden = false
            planView.setData(plan: plan!, lineChart: lineChart)
        }
    }
    
    private func isModeCorrect(plan: Plan) -> Bool {
        return (plan.type == PlanType.time && chartMode == ChartMode.chartModeTime) ||
        (plan.type == PlanType.distance && chartMode == ChartMode.chartModeDistance)
    }
    
    //MARK: views
    private func initView() {
        let stackViewL = UIStackView()
        stackViewL.axis = .horizontal
        stackViewL.distribution = .fillEqually
        stackViewL.spacing = margin
        stackViewL.addArrangedSubview(labelT200)
        stackViewL.addArrangedSubview(labelT500)
        stackViewL.addArrangedSubview(labelT1000)
        
        let stackViewR = UIStackView()
        stackViewR.axis = .horizontal
        stackViewR.distribution = .fillEqually
        stackViewR.spacing = margin
        stackViewR.addArrangedSubview(labelStrokes)
        stackViewR.addArrangedSubview(labelForce)
        stackViewR.addArrangedSubview(labelSpeed)
        
        let stackViewLabels = UIStackView()
        stackViewLabels.axis = .vertical
        stackViewLabels.distribution = .fillEqually
        stackViewLabels.spacing = margin
        stackViewLabels.addArrangedSubview(stackViewL)
        stackViewLabels.addArrangedSubview(stackViewR)
        
        let viewLabels = UIView()
        viewLabels.addSubview(stackViewLabels)
        stackViewLabels.snp.makeConstraints { (make) in
            make.edges.equalTo(viewLabels).inset(UIEdgeInsetsMake(0, margin, 0, margin))
        }
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = margin05
        mainStackView.addArrangedSubview(viewLabels)
        mainStackView.addArrangedSubview(lineChart)
        mainStackView.addArrangedSubview(planView)
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        planView.snp.makeConstraints { (make) in
            make.left.equalTo(lineChart).offset(margin2)
            make.right.equalTo(lineChart).offset(-margin)
        }
        //TODO: not so elegant solution
        //TODO: it not works: on the other views (sumView...) will be visible if zoomed
        let viewLeft = UIView()
        viewLeft.backgroundColor = Colors.colorPrimary
        mainStackView.addSubview(viewLeft)
        viewLeft.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(margin2)
            make.bottom.equalToSuperview()
            make.height.equalTo(timeLineHeight)
        }
        let viewRight = UIView()
        viewRight.backgroundColor = Colors.colorPrimary
        mainStackView.addSubview(viewRight)
        viewRight.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(timeLineHeight)
        }
        ///////////////////////////////////
    }
    
    private lazy var planView: PlanTimeLineView! = {
        let view = PlanTimeLineView()
        
        return view
    }()
    
    private lazy var lineChart: LineChartView! = {
        let chart = LineChartView()
        
        return chart
    }()
    
    private lazy var labelT200: LabelT200! = {
        let label = LabelT200()
        
        label.labelSelectedListener = self.labelT200Listener
        
        return label
    }()
    
    private lazy var labelT500: LabelT500! = {
        let label = LabelT500()
        
        label.labelSelectedListener = self.labelT500Listener
        
        return label
    }()
    
    private lazy var labelT1000: LabelT1000! = {
        let label = LabelT1000()
        
        label.labelSelectedListener = self.labelT1000Listener
        
        return label
    }()
    
    private lazy var labelStrokes: LabelStroke! = {
        let label = LabelStroke()
        
        label.labelSelectedListener = self.labelListener
        
        return label
    }()
    
    private lazy var labelForce: LabelForce! = {
        let label = LabelForce()
        
        label.labelSelectedListener = self.labelListener
        
        return label
    }()
    
    private lazy var labelSpeed: LabelSpeed! = {
        let label = LabelSpeed()
        
        label.labelSelectedListener = self.labelListener
        
        return label
    }()
    
    //MARK: listeners
    private func labelT200Listener(_ label: DiagramLabel) {
        labelT200.isActive = true
        labelT500.isActive = false
        labelT1000.isActive = false
        refreshChart()
    }
    
    private func labelT500Listener(_ label: DiagramLabel) {
        labelT200.isActive = false
        labelT500.isActive = true
        labelT1000.isActive = false
        refreshChart()
    }
    
    private func labelT1000Listener(_ label: DiagramLabel) {
        labelT200.isActive = false
        labelT500.isActive = false
        labelT1000.isActive = true
        refreshChart()
    }
    
    private func labelListener(_ label: DiagramLabel) {
        refreshChart()
    }
    
}
