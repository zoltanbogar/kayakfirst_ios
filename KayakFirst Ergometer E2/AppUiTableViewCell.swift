//
//  AppUiTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class AppUITableViewCell<E>: UITableViewCell {
    
    //MARK: data
    var data: E? {
        didSet {
            initData(data: data)
        }
    }
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(initView())
        initView().snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: abstract functions
    func initData(data: E?) {
        fatalError("Must be implemented")
    }
    
    func initView() -> UIView {
        fatalError("Must be implemented")
    }
    
    func getRowHeight() -> CGFloat {
        fatalError("Must be implemented")
    }
    
    //MARK: selection design
    @IBInspectable var selectionColor: UIColor = UIColor.clear {
        didSet {
            configureSelectedBackgroundView()
        }
    }
    
    private func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
    }
}
