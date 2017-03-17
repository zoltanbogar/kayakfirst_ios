//
//  UploadUtils.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class UploadUtils<E>: ServerService<E> {
    
    //MARK: properties
    private let preferences = UserDefaults.standard
    var timeStamp: Double = 0
    
    //MARK: abstract functions
    func getKeyTimeStamp() -> String {
        fatalError("Must be implemented")
    }
    
    func getTimestamp() -> Double {
        return preferences.double(forKey: self.getKeyTimeStamp())
    }
    
    func setTimestamp(timestamp: Double) {
        if timestamp != 0 {
            preferences.set(timestamp, forKey: self.getKeyTimeStamp())
            preferences.synchronize()
        }
    }
    
}
