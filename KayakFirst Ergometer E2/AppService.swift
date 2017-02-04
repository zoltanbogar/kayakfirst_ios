//
//  AppService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AppService {
    
    func runWithTokenCheck<E>(serverService: ServerService<E>) -> E? {
        return serverService.run()
    }
    
    private func refreshUserToken() {
        //TODO
    }
}
