//
//  Telemetry.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class Telemetry {
    
    //MARK: init
    static let sharedInstance: Telemetry = Telemetry()
    private init() {
        //private constructor
    }
    
    //MARK: properties
    var force: Double = 0
    var force_av: Double = 0
    var speed: Double = 0
    var speed_av: Double = 0
    var distance: Double = 0
    var duration: TimeInterval = 0
    var strokes: Double = 0
    var storkes_av: Double = 0
    var t_200: Double = 0
    var t_200_av: Double = 0
    var t_500: Double = 0
    var t_500_av: Double = 0
    var t_1000: Double = 0
    var t_1000_av: Double = 0
}
