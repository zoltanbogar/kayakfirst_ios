//
//  CalculateElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

let converSationMpsKmph: Double = 3.6
let maxSpeedKmph: Double = 30
let minSpeedKmh: Double = 2

class CalculateElement<M: MeasureCommand, S: CommandProcessor<M>> {
    
    //MARK constants
    let oneMinuteInMillisec: Double = 60 * 1000
    let j = 0.02527962
    let q: Double = 1
    let rh = 0.027
    let c = 0.1419262
    let weightBoat: Double = 12
    let weightBodyDefault: Double = 78
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    let userManager = UserManager.sharedInstance
    let startCommand: S
    
    var calculatedValue: Double = 0
    
    private let trainingManager = TrainingManager.sharedInstance
    
    //MARK: init
    init(startCommand: S) {
        self.startCommand = startCommand
    }
    
    //MARK: abstract functions
    func run() -> Double {
        fatalError("Must be implemented")
    }
    
    func getDataType() -> CalculateEnum {
        fatalError("Must be implemented")
    }
    
    func getWeight() -> Double {
        var bodyWeight: Double? = weightBodyDefault
        
        let user = userManager.getUser()
        
        if let userValue = user {
            bodyWeight = userValue.bodyWeight
        }
        
        return bodyWeight! + weightBoat
    }
}
