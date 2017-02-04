//
//  ErrorDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ErrorDialog: BaseDialog {
    
    init(errorString: String) {
        super.init(title: nil, message: errorString)
        
        showPositiveButton(title: getCapitalizedString("other_ok"))
    }
    
}
