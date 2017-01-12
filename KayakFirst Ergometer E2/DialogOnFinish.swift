//
//  DialogOnFinish.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DialogOnFinish: BaseDialog {
    
    init() {
        super.init(title: try! getString("dialog_title_finish"), message: try! getString("dialog_message_finish"))
        
        showNegativeButton(title: try! getString("other_no"))
        showPositiveButton(title: try! getString("other_yes"))
    }
    
    override func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        //TODO
    }
    
}
