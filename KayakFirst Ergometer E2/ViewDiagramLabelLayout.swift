//
//  ViewDiagramLabelLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewDiagramLabelLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    lazy var textField: UITextField! = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = textField.font?.withSize(12)
        
        return textField
    }()
    
}
