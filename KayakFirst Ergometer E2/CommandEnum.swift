//
//  CommandEnum.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 07..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum CommandEnum: String {
    
    //ergometer
    case tMin = "1"
    case tH = "2"
    case tMax = "3"
    case tV = "4"
    case rpm = "5"
    case reset = "9"
    
    //outdoor
    case location = "location"
    case stroke = "stroke"
    
}
