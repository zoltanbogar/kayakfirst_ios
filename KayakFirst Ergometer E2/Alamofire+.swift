//
//  Alamofire+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 01..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire

let alamofireLogTag = "alamofireLog"

extension Request {
    public func debugLog() -> Self {
        log(alamofireLogTag, "\(self)")
        return self
    }
}
