//
//  CommandParser.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 07..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class CommandParser {
    
    //MARK: constants
    private static let separateCharacter = "/"
    
    class func getDouble(stringValue: String) -> Double {
        return Double(stringValue)!
    }
    
    class func getString(value: Double) -> String {
        return String(value)
    }
    
    class func getString(location: CLLocation?) -> String? {
        let appLocation = AppLocation.newAppLocation(location: location)
        
        guard location != nil else {
            return nil
        }
        
        return "\(appLocation!.latitude)\(separateCharacter)\(appLocation!.longitude)\(separateCharacter)\(appLocation!.speed)"
    }
    
    class func getAppLocation(applocationString: String?) -> AppLocation? {
        guard applocationString != nil else {
            return nil
        }
        let separatedString: [String] = applocationString!.components(separatedBy: separateCharacter)
        let latitude = getDouble(stringValue: separatedString[0])
        let longitude = getDouble(stringValue: separatedString[1])
        let speed = getDouble(stringValue: separatedString[2])
        
        return AppLocation(
            latitude: latitude,
            longitude: longitude,
            speed: speed)
    }
    
}
