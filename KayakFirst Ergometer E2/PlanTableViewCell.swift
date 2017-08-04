//
//  PlanTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanTableViewCell: AppUITableViewCell<Plan> {
    
    //MARK: properties
    private let stackView = UIStackView()
    private var plan: Plan?
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
    override func initData(data: Plan?) {
        self.plan = data
        labelName.text = data?.name
        btnType.setImage(Plan.getTypeIconSmall(plan: data), for: .normal)
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        let nameMarginView = WeightView(weight: EventTabLeViewCell.nameMarginWeight)
        
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(btnType)
        stackView.addArrangedSubview(nameMarginView)
        stackView.addArrangedSubview(labelName)
        stackView.addArrangedSubview(btnAddToCalendar)
        stackView.addArrangedSubview(btnDelete)
        
        return stackView
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var playView: WeightView! = {
        let view = WeightView(weight: EventTabLeViewCell.playWeight)
        
        view.addSubview(self.btnPlay)
        self.btnPlay.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        return view
    }()
    
    private lazy var btnPlay: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        button.backgroundColor = Colors.colorGreen
        button.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelName: WeightLabel! = {
        let label = WeightLabel(weight: EventTabLeViewCell.nameWeight)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var btnType: WeightButton! = {
        let button = WeightButton(weight: EventTabLeViewCell.deleteWeight)
        
        return button
    }()
    
    private lazy var btnAddToCalendar: WeightButton! = {
        let button = WeightButton(weight: EventTabLeViewCell.deleteWeight)
        let image = UIImage(named: "addCalendar")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickAddToCalendar), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnDelete: WeightButton! = {
        let button = WeightButton(weight: EventTabLeViewCell.deleteWeight)
        let image = UIImage(named: "trashSmall")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func clickPlay() {
        if Validate.isValidPlan(viewController: viewController()!, plan: plan) {
            if viewController()!.parent is UINavigationController {
                startMainVc(navigationViewController: viewController()!.parent as! UINavigationController, plan: plan, event: nil)
            }
        }
    }
    
    @objc private func clickAddToCalendar() {
        startEventDetailsViewController(viewController: viewController()!, plan: plan!)
    }
    
    @objc private func clickDelete() {
        DeletePlanDialog.showDeletePlanDialog(viewController: viewController()!, plan: plan!, managerCallback: deleteCallback)
    }
}
