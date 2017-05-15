//
//  PlanEditIntervallsCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 15..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanEditIntervallsCell: AppUITableViewCell<Any> {
    
    //MARK: properties
    private let view = UIView()
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: Any?) {
        //nothing here
    }
    
    //MARK: init view
    override func initView() -> UIView {
        
        view.addSubview(viewEdit)
        viewEdit.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
        }
        
        return view
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var viewEdit: UIView! = {
        let view = UIStackView()
        view.axis = .horizontal
        
        view.addArrangedSubview(self.imgEdit)
        view.addArrangedSubview(self.labelEdit)
        
        return view
    }()
    
    private lazy var labelEdit: UILabel! = {
        let label = UILabel()
        label.text = getString("plan_edit_intervals")
        
        return label
    }()
    
    private lazy var imgEdit: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "edit")
        
        imageView.image = image
        
        return imageView
    }()
}
