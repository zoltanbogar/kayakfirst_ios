//
//  UnitHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 23..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class UnitHelper {
    
    //MARK: constants
    private static let userManager = UserManager.sharedInstance
    
    class func getDistanceUnit() -> String {
        if isMetricDistance() {
            return getString("unit_distance_metric")
        } else {
            return getString("unit_distance_imperial")
        }
    }
    
    class func getWeightUnit(isMetric: Bool) -> String {
        if isMetric {
            return getString("unit_weight_metric")
        } else {
            return getString("unit_weight_imperial")
        }
    }
    
    class func getDistanceValue(metricValue: Double) -> Double {
        if isMetricDistance() {
            return metricValue
        } else {
            return metricValue * 3.280839895
        }
    }
    
    class func getMetricDistanceValue(value: Double) -> Double {
        if isMetricDistance() {
            return value
        } else {
            return value * 0.3048
        }
    }
    
    class func getMetricWeightValue(value: Double, isMetric: Bool) -> Double {
        if isMetric {
            return value
        } else {
            return value * 0.453592
        }
    }
    
    class func getSpeedValue(metricValue: Double) -> Double {
        if isMetricDistance() {
            return metricValue
        } else {
            return metricValue * 0.621371
        }
    }
    
    //TODO: lbs is for 'kg' not for 'Newton'
    class func getForceValue(metricValue: Double) -> Double {
        if isMetricWeight() {
            return metricValue
        } else {
            return metricValue * 0.224808942443
        }
    }
    
    class func getPaceValue(pace: Int, metricValue: Double) -> Double {
        var value: Double = 0
        if isMetricDistance() {
            value = metricValue
        } else {
            var correction: Double = 1
            switch pace {
            case 200:
                correction = 0.25
            case 500:
                correction = 0.5
            case 1000:
                correction = 1
            default:
                break
            }
            value = (metricValue / Double(pace)) * correction
        }
        return value
    }
    
    class func getTrainingValue(training: Training?) -> Double {
        var value: Double = 0
        
        if let trainingValue = training {
            switch trainingValue.dataType {
            case CalculateEnum.F.rawValue:
                value = getForceValue(metricValue: trainingValue.dataValue)
            case CalculateEnum.V.rawValue:
                value = getSpeedValue(metricValue: trainingValue.dataValue)
            case CalculateEnum.STROKES.rawValue:
                value = trainingValue.dataValue
            case CalculateEnum.T_200.rawValue:
                value = getPaceValue(pace: 200, metricValue: trainingValue.dataValue)
            case CalculateEnum.T_500.rawValue:
                value = getPaceValue(pace: 500, metricValue: trainingValue.dataValue)
            case CalculateEnum.T_1000.rawValue:
                value = getPaceValue(pace: 1000, metricValue: trainingValue.dataValue)
            case CalculateEnum.S_SUM.rawValue:
                value = getDistanceValue(metricValue: trainingValue.dataValue)
            default:
                break
            }
        }
        return value
    }
    
    class func getCalculatePaceTitle(pace: Int) -> String {
        switch pace {
        case 200:
            if isMetricPace() {
                return getString("calculate_t200_metric")
            } else {
                return getString("calculate_t200_imperial")
            }
        case 500:
            if isMetricPace() {
                return getString("calculate_t500_metric")
            } else {
                return getString("calculate_t500_imperial")
            }
        case 1000:
            if isMetricPace() {
                return getString("calculate_t1000_metric")
            } else {
                return getString("calculate_t1000_imperial")
            }
        default:
            fatalError("there is no other pace")
        }
    }
    
    class func isMetricWeight() -> Bool {
        var isImperial = false
        
        if let user = userManager.getUser() {
            isImperial = user.unitWeight == User.unitImperial
        }
        //return !isImperial
        return false
    }
    
    class func isMetricDistance() -> Bool {
        var isImperial = true
        
        if let user = userManager.getUser() {
            isImperial = user.unitDistance == User.unitImperial
        }
        //return !isImperial
        return false
    }
    
    class func isMetricPace() -> Bool {
        var isImperial = true
        
        if let user = userManager.getUser() {
            isImperial = user.unitPace == User.unitImperial
        }
        //return !isImperial
        return false
    }
    
    class func isMetric(keyUnit: String?) -> Bool {
        return keyUnit == nil || User.unitMetric == keyUnit!
    }
    
    
}
