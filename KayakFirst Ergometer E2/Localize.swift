//
//  Localize.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

public func getString(_ key: String) -> String {
    let localizedString = NSLocalizedString(key, comment: "")
    
    if localizedString == key {
        fatalError("Localizable key does not exists: \(key)")
    }
    
    return NSLocalizedString(key, comment: "")
}

public func getCapitalizedString(_ key: String) -> String {
    let string = getString(key)
    return string.capitalized
}

extension String: Error{}
