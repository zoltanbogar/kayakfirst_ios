//
//  CommandErgometerT_V.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandErgometerT_V: MeasureCommandErgometer {
    
    override func getCommand() -> String {
        return CommandErgometerEnum.tV.rawValue
    }
}
