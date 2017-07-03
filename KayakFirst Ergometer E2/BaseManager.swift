//
//  BaseManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseManager {
    
    //MARK: properties
    var stack: BaseManager?
    var serverService: ServerService<AnyObject>?
    
    func runUser<E>(serverService: ServerService<E>, managerCallBack: @escaping (_ error: Responses?, _ userData: E?) -> ()) {
        
    }
    
    //TODO
    private func shouldRun(serverService: ServerService<AnyObject>) -> Bool {
        if self.serverService != nil {
            return true
        } else {
            return true
        }
    }
    
}
