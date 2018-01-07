//
//  CommandOutdoorLocation.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 07..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class CommandOutdoorLocation: MeasureCommandOutdoor {
    
    //MARK: properties
    private var location: CLLocation?
    
    //MARK: functions
    func setLocation(location: CLLocation) {
        self.location = location
    }
    
    override func setValue(stringValue: String) -> Bool {
        //nothing here
        return true
    }
    
    override func getValue() -> String? {
        return CommandParser.getString(location: location)
    }
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.location
    }
    
}
