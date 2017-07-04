//
//  ManagerModify.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModify<E: ModifyAble>: ManagerUpload {
    
    //MARK: properties
    internal var data: E?
    
    //MARK: init
    init(data: E?) {
        self.data = data
    }
    
    //MARK: functions
    func getPointer() -> String? {
        return data?.getUploadPointer() as! String
    }
    
    //MARK: abstract functions
    func modifyLocale() {
        fatalError("must be implemented")
    }
    
}
