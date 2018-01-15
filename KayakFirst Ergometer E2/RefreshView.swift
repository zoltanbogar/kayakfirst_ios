//
//  RefreshView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class RefreshView<E: BaseLayout>: CustomUi<E> {
    
    //MARK: abstract functions
    func refreshUi() {
        fatalError("must be implemented")
    }
    
}
