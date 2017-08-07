//
//  StartCommandErgometer.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class StartCommandErgometer: StartCommand<MeasureCommandErgometer> {
    
    //MARK: properties
    var t_min: Double = 0
    var t_min_future: Double = 0
    var t_h: Double = 0
    var t_h_future: Double = 0
    var t_max: Double = 0
    
    var p: Double = 0
    var omegaMax: Double = 0
    var omegaMin: Double = 0
    
}
