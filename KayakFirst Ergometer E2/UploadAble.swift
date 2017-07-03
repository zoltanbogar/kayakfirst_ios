//
//  UploadAble.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol UploadAble {
    associatedtype E
    func getUploadPointer() -> E
    func getParameters() -> [String:Any]
}
