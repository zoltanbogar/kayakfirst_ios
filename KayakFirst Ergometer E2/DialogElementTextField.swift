//
//  DialogElementTextField.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DialogElementTextField: BaseDialogElementTextField<ViewDialogElementTextFieldLayout> {
    
    override func getContentLayout(contentView: UIView) -> ViewDialogElementTextFieldLayout {
        return ViewDialogElementTextFieldLayout(contentView: contentView)
    }
}
