//
//  PickerHelperUnitDistance.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 23..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PickerHelperUnit: PickerHelper {
    
    //MARK: constants
    static let unitOptions = [getString("unit_metric"), getString("unit_imperial")]
    
    //MARK: functions
    override func getOptions() -> [String] {
        return PickerHelperUnit.unitOptions
    }
    
    override func getTitle(value: String) -> String {
        if value == User.unitImperial {
            return getString("unit_imperial")
        } else {
            return getString("unit_metric")
        }
    }
    
    override func getValue() -> String? {
        let metricLocalized = getString("unit_metric")
        let imperialLocalized = getString("unit_imperial")
        if textField.text == metricLocalized {
            return User.unitMetric
        } else if textField.text == imperialLocalized {
            return User.unitImperial
        }
        return nil
    }
}
