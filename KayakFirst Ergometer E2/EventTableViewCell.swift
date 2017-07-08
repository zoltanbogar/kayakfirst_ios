//
//  PlanTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventTabLeViewCell: AppUITableViewCell<PlanEvent> {
    
    //MARK: constants
    static let playWidth = 80
    static let doneWidth = 150
    
    //MARK: properties
    private let stackView = UIStackView()
    private var planEvent: PlanEvent?
    var deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init data
    override func initData(data: PlanEvent?) {
        self.planEvent = data
        labelName.text = data?.event.name
        doneView.isHidden = data?.event.sessionId == 0
        
        initPlayEnable()
    }
    
    private func initPlayEnable() {
        let isEnable = DateFormatHelper.isSameDay(timeStamp1: (planEvent?.event.timestamp)!, timeStamp2: currentTimeMillis())
        
        let color: UIColor?
        
        if isEnable {
            color = Colors.colorGreen
            
            btnPlay.alpha = 1
            
            btnPlay.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        } else {
            color = Colors.colorGrey
            
            btnPlay.alpha = 0.5
            
            btnPlay.removeTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        }
        btnPlay.color = color!
    }
    
    //MARK: button listeners
    @objc private func clickPlay() {
        if Validate.isValidPlan(viewController: viewController()!, plan: planEvent?.plan) {
            startMainVc(navigationViewController: (viewController()?.navigationController)!, plan: planEvent?.plan, event: planEvent?.event)
        }
    }
    
    @objc private func clickDelete() {
        DeleteEventDialog.showDeleteEventDialog(viewController: viewController()!, event: planEvent!.event, managerCallback: deleteCallback)
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(labelName)
        stackView.addArrangedSubview(imgDone)
        stackView.addArrangedSubview(btnDelete)
        
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
        
        return button
    }()
    
    private lazy var labelName: UILabel! = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var doneView: UIView! = {
        let view = UIView()
        
        view.addSubview(self.imgDone)
        self.imgDone.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(EventTabLeViewCell.doneWidth)
        })
        
        return view
    }()
    
    private lazy var imgDone: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doneTrue")
        
        return imageView
    }()
    
    private lazy var btnDelete: UIButton! = {
        let button = UIButton()
        let image = UIImage(named: "trashSmall")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        
        return button
    }()
}
