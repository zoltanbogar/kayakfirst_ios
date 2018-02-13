//
//  DatabaseHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseDbHelper<E> {
    
    func run() -> E? {
        fatalError("must be implemented")
    }
    
}
