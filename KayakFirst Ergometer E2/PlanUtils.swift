//
//  PlanUtils.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func getPlanElementColor(planElement: PlanElement?) -> UIColor {
    var color = Colors.colorPlanHard
    
    if let element = planElement {
        if element.intensity < 33 {
            color = Colors.colorPlanLight
        } else if element.intensity >= 33 && element.intensity < 66 {
            color = Colors.colorPlanMedium
        } else if element.intensity >= 66 {
            color = Colors.colorPlanHard
        }
    }
    
    return color
}
