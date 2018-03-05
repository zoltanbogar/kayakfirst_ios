//
//  ManagerDownloadNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 25..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol ManagerDownloadProtocol {
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool
}

class ManagerDownload<DATA>: ManagerDownloadProtocol {
    
    var serverError: Responses?
    
    func getData() -> DATA? {
        fatalError("must be implemented")
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        fatalError("must be implemented")
    }
    
}
