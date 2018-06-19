//
//  Connection+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 06. 19..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import SQLite

extension Connection {
    public var userVersion: Int {
        get { return try! Int(scalar("PRAGMA user_version") as! Int64) }
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
