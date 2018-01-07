//
//  CommandErgometerT_H.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandErgometerT_H: MeasureCommandErgometer {
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.tH
    }
}
