//
//  PlanTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventTabLeViewCell: AppUITableViewCell<Event> {
    
    //MARK: constants
    static let playWidth = 80
    static let doneWidth = 150
    var hasDone: Bool = false
    
    //MARK: properties
    private let stackView = UIStackView()
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: Event?) {
        labelName.text = data?.name
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(labelName)
        
        if hasDone {
            stackView.addArrangedSubview(doneView)
        }
        
        return stackView
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var playView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.btnPlay)
        self.btnPlay.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(EventTabLeViewCell.playWidth)
        })
        
        return view
    }()
    
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
    
    private lazy var doneView: UIView! = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doneTrue")
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(EventTabLeViewCell.doneWidth)
        })
        
        return view
    }()
    
    //MARK: button listeners
    @objc private func clickPlay() {
        log("PLAN_TEST", "clickPlayInList")
    }
    
}
