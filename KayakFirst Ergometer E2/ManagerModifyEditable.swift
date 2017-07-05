//
//  ManagerModifyEditable.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyEditable<E: ModifyAble>: ManagerModify<E> {
    
    //MARK: properties
    var isEdit = false
    
    //MARK: functions
    override func getPointer() -> String? {
        let originalPointer: String = data?.getUploadPointer() as! String
        let pointer = originalPointer + "+" + "\(isEdit)"
        return pointer
    }
    
    internal func getIsEditFromPointer(pointer: String) -> Bool {
        return pointer.contains("true")
    }
    
    internal func removeEditPointer(pointer: String) -> String {
        let splitted = pointer.components(separatedBy: "+")
        return splitted[0]
    }
}
