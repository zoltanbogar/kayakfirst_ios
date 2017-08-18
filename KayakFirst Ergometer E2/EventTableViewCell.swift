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
    
    static let playWeight: CGFloat = 1
    static let nameMarginWeight: CGFloat = 0.2
    static let nameWeight: CGFloat = 3
    static let doneWeight: CGFloat = 1
    static let deleteWeight: CGFloat = 1
    
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
        labelName.text = data?.plan.name
        
        var doneImage: UIImage?
        if data?.event.sessionId == 0 {
            doneImage = UIImage(named: "")
        } else {
            doneImage = UIImage(named: "doneTrue")
        }
        btnDone.setImage(doneImage, for: .normal)
        
        initPlayEnable()
    }
    
    private func initPlayEnable() {
        var isEnable = DateFormatHelper.isSameDay(timeStamp1: (planEvent?.event.timestamp)!, timeStamp2: currentTimeMillis())
        isEnable = isEnable && planEvent!.event.sessionId == 0
        
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
        DeleteEventDialog.showDeleteEventDialog(viewController: viewController()!, planEvent: planEvent!, managerCallback: deleteCallback)
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        let marginView = WeightView(weight: EventTabLeViewCell.nameMarginWeight)
        
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(marginView)
        stackView.addArrangedSubview(labelName)
        stackView.addArrangedSubview(btnDone)
        stackView.addArrangedSubview(btnDelete)
        
        return stackView
    }
    
    //TODO - refactor: rowHeights not correct when open first
    override func getRowHeight() -> CGFloat {
        var newTextViewHeight = ceil(labelName.sizeThatFits(labelName.frame.size).height)
        
        if newTextViewHeight < trainingRowHeight {
            newTextViewHeight = trainingRowHeight
        } else {
            newTextViewHeight += margin05
        }
        
        return newTextViewHeight
    }
    
    //MARK: views
    private lazy var playView: WeightView! = {
        let view = WeightView(weight: EventTabLeViewCell.playWeight)
        
        view.addSubview(self.btnPlay)
        self.btnPlay.snp.makeConstraints { (make) in
            make.center.equalTo(view).priority(1)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        return view
    }()
    
    private lazy var btnPlay: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        button.backgroundColor = Colors.colorGreen
        
        return button
    }()
    
    private lazy var labelName: WeightLabel! = {
        let label = WeightLabel(weight: EventTabLeViewCell.nameWeight)
        label.font = label.font.withSize(TrainingTablewViewCell.fontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var btnDone: WeightButton! = {
        let button = WeightButton(weight: EventTabLeViewCell.doneWeight)
        
        return button
    }()
    
    private lazy var btnDelete: WeightButton! = {
        let button = WeightButton(weight: EventTabLeViewCell.deleteWeight)
        let image = UIImage(named: "trashSmall")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        
        return button
    }()
}
