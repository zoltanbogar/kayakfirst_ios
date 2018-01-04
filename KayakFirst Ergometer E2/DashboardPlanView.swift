//
//  DashboardPlanView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardPlanView: RefreshView<ViewDashboardPlanLayout> {
    
    private let telemetry = Telemetry.sharedInstance
    
    //MARK: properties
    var plan: Plan? {
        didSet {
            resetPlan()
        }
    }
    var isDone: Bool {
        return planElementPosition == plan?.planElements?.count
    }
    private var localeValue: Double = 0
    private var planElementPosition: Int = 0
    let planSoundHelper = PlanSoundHelper.sharedInstance
    
    override func getContentLayout(contentView: UIView) -> ViewDashboardPlanLayout {
        return ViewDashboardPlanLayout(contentView: contentView)
    }
    
    //MARK: functions
    func viewDidLayoutSubViews() {
        contentLayout!.viewGrad.superview?.layer.mask = getGradient(withColours: [Colors.colorPrimary, Colors.colorTransparent], gradientOrientation: .verticalSlow)
    }
    
    func resetPlan() {
        localeValue = 0
        planElementPosition = 0
        
        contentLayout!.peTableView.dataList = self.plan?.planElements
        
        setProgressBarPlanElementColor()
    }
    
    override func startRefresh(_ isStart: Bool) {
        if isStart {
            super.startRefresh(true)
        }
        
        contentLayout!.deActual1000.startRefresh(isStart)
        contentLayout!.deSpm.startRefresh(isStart)
        
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
                
                contentLayout!.progressViewComplete.progress = Float(totalPercent / 100)
                contentLayout!.progressViewPlanElement.progress = (Float((Double(1) - currentPercent)))
                
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
        contentLayout!.labelValue.text = valueText
        contentLayout!.labelValueAccent.text = valueAccentText
    }
    
    private func reset() {
        localeValue = telemetry.distance
        
        if plan!.type == PlanType.distance {
            localeValue = telemetry.duration
        }
        
        setTextsByPercent(percent: 0)
        contentLayout!.peTableView.removePlanElement(position: 0)
        
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
        
        contentLayout!.progressViewPlanElement.trackTintColor = color
    }
    
}
