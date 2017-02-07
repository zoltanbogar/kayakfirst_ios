//
//  TrainingTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingTablewViewCell: AppUITableViewCell<Training> {
    
    //MARK: constants
    private let rowHeight = 40
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initData(data: Training?) {
        labelTest.text = "\(data?.dataType): \(data?.dataValue)"
    }
    
    override func initView() -> UIView {
        return labelTest
    }
    
    override func getRowHeight() -> Int {
        return rowHeight
    }
    
    //MARK: views
    lazy var labelTest: AppUILabel! = {
        let label = AppUILabel()
        
        return label
    }()

    
}
