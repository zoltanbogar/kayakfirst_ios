//
//  CommandErgometerT_MAX.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandErgometerT_MAX: MeasureCommandErgometer {
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.tMax
    }
}
