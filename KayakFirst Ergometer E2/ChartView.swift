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

class ChartView: CustomUi<ViewChartLayout> {
    
    //MARK: properties
    private var sumTraining: SumTrainingNew!
    private var lineChartData: AppLineChartData?
    private var diagramLabelList: [DiagramLabel]?
    private var chartMode: ChartMode?
    
    //MARK: init
    init(sumTraining: SumTrainingNew, chartMode: ChartMode) {
        self.sumTraining = sumTraining
        super.init()
        
        self.chartMode = chartMode
        
        disableLabelIfNeeded()
        initLabelList()
        initChart()
        initPlanTimeLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: views
    override func initView() {
        super.initView()
        
        contentLayout!.labelT200.labelSelectedListener = self.labelT200Listener
        contentLayout!.labelT500.labelSelectedListener = self.labelT500Listener
        contentLayout!.labelT1000.labelSelectedListener = self.labelT1000Listener
        contentLayout!.labelStrokes.labelSelectedListener = self.labelListener
        contentLayout!.labelForce.labelSelectedListener = self.labelListener
        contentLayout!.labelSpeed.labelSelectedListener = self.labelListener
    }
    
    override func getContentLayout(contentView: UIView) -> ViewChartLayout {
        return ViewChartLayout(contentView: contentView)
    }
    
    private func initLabelList() {
        diagramLabelList = [
            contentLayout!.labelT200,
            contentLayout!.labelT500,
            contentLayout!.labelT1000,
            contentLayout!.labelStrokes,
            contentLayout!.labelSpeed,
            contentLayout!.labelForce]
    }
    
    private func initChart() {
        contentLayout!.progressBar.showProgressBar(false)
        
        TrainingManager.sharedInstance.getChartData(sessionId: sumTraining.sessionId, managerCallback: { (sumChartTraining, error) in
            if let data = sumChartTraining {
                if self.chartMode! == ChartMode.chartModeDistance {
                    self.lineChartData = LineChartDistance(lineChart: self.contentLayout!.lineChart, sumChartTraining: data)
                } else {
                    self.lineChartData = LineChartTime(lineChart: self.contentLayout!.lineChart, sumChartTraining: data)
                }
                self.refreshChart()
            }
            })
    }
    
    private func refreshChart() {
        lineChartData?.createTrainingListByLabel(diagramLabels: diagramLabelList!)
    }
    
    private func disableLabelIfNeeded() {
        let isOutdoor = sumTraining.trainingEnvironmentType == TrainingEnvironmentType.outdoor.rawValue
        
        if isOutdoor {
            contentLayout!.labelForce.isDisabled = true
        }
    }
    
    private func initPlanTimeLine() {
        //TODO
        /*let plan = sumTraining.planTraining
        
        contentLayout!.planView.isHidden = true
        
        if plan != nil && isModeCorrect(plan: plan!) {
            contentLayout!.planView.isHidden = false
            contentLayout!.planView.setData(plan: plan!, lineChart: contentLayout!.lineChart)
        }*/
    }
    
    private func isModeCorrect(plan: Plan) -> Bool {
        return (plan.type == PlanType.time && chartMode == ChartMode.chartModeTime) ||
        (plan.type == PlanType.distance && chartMode == ChartMode.chartModeDistance)
    }
    
    //MARK: listeners
    private func labelT200Listener(_ label: DiagramLabel) {
        contentLayout!.labelT200.isActive = true
        contentLayout!.labelT500.isActive = false
        contentLayout!.labelT1000.isActive = false
        refreshChart()
    }
    
    private func labelT500Listener(_ label: DiagramLabel) {
        contentLayout!.labelT200.isActive = false
        contentLayout!.labelT500.isActive = true
        contentLayout!.labelT1000.isActive = false
        refreshChart()
    }
    
    private func labelT1000Listener(_ label: DiagramLabel) {
        contentLayout!.labelT200.isActive = false
        contentLayout!.labelT500.isActive = false
        contentLayout!.labelT1000.isActive = true
        refreshChart()
    }
    
    private func labelListener(_ label: DiagramLabel) {
        refreshChart()
    }
    
}
