//
//  BaseTraining.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseTraining {
    
    let sessionId: Double
    let force: Double
    let speed: Double
    let strokes: Double
    let t200: Double
    var t500: Double {
        get {
            return t200 / 2 * 5
        }
    }
    var t1000: Double {
        get {
            return t200 / 2 * 10
        }
    }
    
    init(sessionId: Double, force: Double, speed: Double, strokes: Double, t200: Double) {
        self.sessionId = sessionId
        self.force = force
        self.speed = speed
        self.strokes = strokes
        self.t200 = t200
    }
    
    init?(json: JSON) {
        self.sessionId = json["sessionId"].doubleValue
        self.force = json["force"].doubleValue
        self.speed = json["speed"].doubleValue
        self.strokes = json["strokes"].doubleValue
        self.t200 = json["t200"].doubleValue
    }
    
}
