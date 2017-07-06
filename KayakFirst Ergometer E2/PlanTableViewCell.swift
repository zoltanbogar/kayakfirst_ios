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
        Plan.setTypeIcon(plan: data, imageView: imgType)
    }
    
    //MARK: init view
    override func initView() -> UIView {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(playView)
        stackView.addArrangedSubview(imgType)
        stackView.addArrangedSubview(labelName)
        stackView.addArrangedSubview(btnAddToCalendar)
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
        button.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelName: UILabel! = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var imgType: UIImageView! = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var btnAddToCalendar: UIButton! = {
        let button = UIButton()
        let image = UIImage(named: "addCalendar")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private lazy var btnDelete: UIButton! = {
        let button = UIButton()
        let image = UIImage(named: "trashSmall")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func clickPlay() {
        log("PLAN_TEST", "clickPlayInList")
    }
    
    @objc private func clickDelete() {
        DeletePlanDialog.showDeletePlanDialog(viewController: viewController()!, plan: plan!, managerCallback: deleteCallback)
    }
}
