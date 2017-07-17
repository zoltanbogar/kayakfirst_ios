//
//  UploadAbleDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class UploadAbleDbLoader<IN: UploadAble, UPLOAD>: BaseDbLoader<IN> {
    
    //MARK: abstract functions
    func loadUploadAbleData(pointer: UPLOAD) -> [IN]? {
        fatalError("must be implemented")
    }
    
    func getDeleteOldDataPredicate() -> Expression<Bool> {
        fatalError("must be implemented")
    }
    
}
