//
//  PlanDisplayHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 19..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanDisplayHelper {
    
    //MARK: properties
    private let telemetry: Telemetry
    
    private var plan: Plan?
    private var planElements: [PlanElement]?
    private var planElementsOriginal: [PlanElement]?
    
    private var duration: Double = 0
    private var distance: Double = 0
    
    private var planElementPosition: Int = 0
    private var localeValue: Double = 0
    private var showPosition: Int = -1
    
    private var planElementColor = Colors.colorAccent
    private var value: Double = 0
    private var valueAccent: Double = 0
    private var totalProgress: Double = 0
    private var actualProgress: Double = 0
    private var isDone = false
    
    //MARK: init
    private static var instance: PlanDisplayHelper?
    
    class func getInstance(telemetry: Telemetry) -> PlanDisplayHelper {
        if PlanDisplayHelper.instance == nil {
            PlanDisplayHelper.instance = PlanDisplayHelper(telemetry: telemetry)
        }
        return PlanDisplayHelper.instance!
    }
    
    private init(telemetry: Telemetry) {
        self.telemetry = telemetry
    }
    
    public func setPlane(plan: Plan?) {
        self.plan = plan
        if plan != nil && plan!.planElements != nil {
            planElements = plan!.planElements!.map { $0 }
            planElementsOriginal = plan!.planElements!.map { $0 }
            
            setData(duration: 0, distance: 0)
        }
    }
    
    //MARK: functions
    func setData(duration: Double, distance: Double) {
        if let plan = plan {
            self.duration = duration
            self.distance = distance
            
            if let planElements = plan.planElements {
                totalProgress = getTotalPercent()
                
                if totalProgress >= 0 {
                    isDone = false
                    
                    setPlanElementPosition()
                    
                    actualProgress = getCurrentPercent()
                } else {
                    isDone = true
                    
                    planElementPosition = planElements.count
                    
                    resetProgress()
                }
                
                setValues()
                
                setToTelemetry()
            }
        }
    }
    
    func reset() {
        duration = 0
        distance = 0
        planElementPosition = 0
        localeValue = 0
        showPosition = -1
        
        planElementColor = Colors.colorAccent
        value = 0
        valueAccent = 0
        totalProgress = 0
        actualProgress = 0
        isDone = false
        
        if plan != nil {
            resetProgress()
        }
    }
    
    private func setToTelemetry() {
        telemetry.planTelemetryObject = getPlanTelemetryObject()
    }
    
    private func getTotalPercent() -> Double {
        if getCurrentTotalValue() > plan!.length {
            return -1
        } else {
            let percent: Double = getCurrentTotalValue() / plan!.length
            
            return (Double(100) * (Double(1) - percent))
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
                    resetProgress()
                }
                break
            }
        }
    }
    
    private func getCurrentPercent() -> Double {
        var percent: Double = 1
        
        if let currentPlanElement = getCurrentPlanElement() {
            var sum: Double = 0
            for i in 0..<planElementPosition {
                sum += plan!.planElements![i].value
            }
            
            let diff = getCurrentTotalValue() - sum
            percent = diff / currentPlanElement.value
        }
        return (1 - percent)
    }
    
    private func getCurrentTotalValue() -> Double {
        var valueToCheck = duration
        if plan!.type == PlanType.distance {
            valueToCheck = distance
        }
        return valueToCheck
    }
    
    private func getCurrentPlanElement() -> PlanElement? {
        if plan != nil && plan!.planElements != nil && planElementPosition < plan!.planElements!.count {
            return plan!.planElements![planElementPosition]
        }
        return nil
    }
    
    private func resetProgress() {
        localeValue = distance
        
        if plan!.type == PlanType.distance {
            localeValue = duration
        }
        
        value = 0
        valueAccent = 0
        actualProgress = 0
        
        setProgressBarPlanElementColor()
        showPlanElementByPosition()
    }
    
    private func setProgressBarPlanElementColor() {
        planElementColor = Colors.colorAccent
        
        if let planElement = getCurrentPlanElement() {
            planElementColor = getPlanElementColor(planElement: planElement)
        }
    }
    
    private func setValues() {
        value = 0
        valueAccent = 0
        
        if let planElement = getCurrentPlanElement() {
            value = actualProgress * planElement.value
            valueAccent = distance - localeValue
            
            if plan!.type == PlanType.distance {
                valueAccent = duration - localeValue
            }
        }
    }
    
    private func showPlanElementByPosition() {
        if planElements != nil && showPosition != planElementPosition {
            var newElements = [PlanElement]()
            
            for i in planElementPosition..<planElementsOriginal!.count {
                newElements.append(planElementsOriginal![i])
            }
            planElements = newElements
        }
        self.showPosition = planElementPosition
    }
    
    private func getPlanTelemetryObject() -> PlanTelemetryObject {
        return PlanTelemetryObject(
            planElementColor: planElementColor,
            planElementList: planElements,
            value: value,
            valueAccent: valueAccent,
            totalProgress: totalProgress,
            actualProgress: 100 * actualProgress,
            isDone: isDone)
    }
    
}
