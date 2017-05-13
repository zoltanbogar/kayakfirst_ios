//
//  PlanTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanTabLeViewCell: AppUITableViewCell<Plan> {
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: Plan?) {
        labelName.text = data?.name
    }
    
    //MARK: init view
    override func initView() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(btnPlay)
        stackView.addArrangedSubview(labelName)
        
        return stackView
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var btnPlay: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        button.backgroundColor = Colors.colorGreen
        button.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelName: UILabel! = {
        let label = UILabel()
        
        return label
    }()
    
    //MARK: button listeners
    @objc private func clickPlay() {
        log("PLAN_TEST", "clickPlayInList")
    }
    
}
