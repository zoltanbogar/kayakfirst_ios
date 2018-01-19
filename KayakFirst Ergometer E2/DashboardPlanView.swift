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
    var plan: Plan?
    var isDone: Bool {
        return planTelemetryObject != nil && planTelemetryObject!.isDone
    }
    let planSoundHelper = PlanSoundHelper.sharedInstance
    
    private var planTelemetryObject: PlanTelemetryObject? = nil
    
    override func getContentLayout(contentView: UIView) -> ViewDashboardPlanLayout {
        return ViewDashboardPlanLayout(contentView: contentView)
    }
    
    //MARK: functions
    func viewDidLayoutSubViews() {
        var gradientOrientation: GradientOrientation = .verticalPortrait
        if contentLayout!.isLandscape {
            gradientOrientation = .verticalLandscape
        }
        contentLayout!.viewGrad.superview?.layer.mask = getGradient(withColours: [Colors.colorPrimary, Colors.colorTransparent], gradientOrientation: gradientOrientation)
    }
    
    override func refreshUi() {
        contentLayout!.deActual1000.refreshUi()
        contentLayout!.deSpm.refreshUi()
        
        planTelemetryObject = telemetry.planTelemetryObject
        
        if let planTelemetryObject = planTelemetryObject {
            setTexts(value: planTelemetryObject.value, accentValue: planTelemetryObject.valueAccent)
            contentLayout!.progressViewComplete.progress = Float(planTelemetryObject.totalProgress / 100)
            contentLayout!.progressViewPlanElement.progress = (Float(planTelemetryObject.actualProgress / 100))
            setProgressBarPlanElementColor(color: planTelemetryObject.planElementColor)
            contentLayout!.peTableView.dataList = planTelemetryObject.planElementList
            
            planSoundHelper.playSoundIfNeeded(value: planTelemetryObject.value, planType: plan!.type)
        }
    }
    
    private func setTexts(value: Double, accentValue: Double) {
        var valueText = getFormattedTimeText(value: value)
        var valueAccentText = getFormattedDistanceText(value: accentValue)
        
        if plan!.type == PlanType.distance {
            valueText = getFormattedDistanceText(value: value)
            valueAccentText = getFormattedTimeText(value: accentValue)
        }
        
        setTexts(valueText: valueText, valueAccentText: valueAccentText)
    }
    
    private func setTexts(valueText: String, valueAccentText: String) {
        contentLayout!.labelValue.text = valueText
        contentLayout!.labelValueAccent.text = valueAccentText
    }
    
    private func getFormattedTimeText(value: Double) -> String {
        return DateFormatHelper.getDate(dateFormat: DateFormatHelper.minSecFormat, timeIntervallSince1970: value)
    }
    
    private func getFormattedDistanceText(value: Double) -> String {
        return "" + "\(Int(value))" + " " + UnitHelper.getDistanceUnit()
    }
    
    private func setProgressBarPlanElementColor(color: UIColor) {
        contentLayout!.progressViewPlanElement.trackTintColor = color
    }
    
}
