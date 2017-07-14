//
//  PlanTypeView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol PlanTypeSelectListener {
    func timeSelected()
    func distanceSelected()
}

class PlanTypeView: UIView {
    
    //MARK: constants
    private let imageHeight: CGFloat = 70
    private let maxTextSize: CGFloat = 56
    
    //MARK: properties
    var planTypeSelectListener: PlanTypeSelectListener?
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initTextHeight()
    }
    
    //MARK: functions
    private func initTextHeight() {
        let width = self.frame.width
        
        var textHeight = width / 8
        
        if textHeight > maxTextSize {
            textHeight = maxTextSize
        }
        
        labelPlanDistance.font = labelPlanDistance.font.withSize(textHeight)
        labelPlanTime.font = labelPlanTime.font.withSize(textHeight)
    }
    
    //MARK: button listener
    @objc private func clickTime() {
        if let listener = planTypeSelectListener {
            listener.timeSelected()
        }
    }
    
    @objc private func clickDistance() {
        if let listener = planTypeSelectListener {
            listener.distanceSelected()
        }
    }
    
    //MARK: init view
    private func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(viewTime)
        
        let halfDivider = HalfDivider()
        stackView.addArrangedSubview(halfDivider)
        
        stackView.addArrangedSubview(viewDistance)
        
        viewTime.snp.makeConstraints { (make) in
            make.width.equalTo(viewDistance)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var viewTime: UIView! = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickTime)))
        view.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "durationIcon")
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints({ (make) in
            make.height.equalTo(self.imageHeight)
        })
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(self.labelPlanTime)
        stackView.addArrangedSubview(imageView)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var labelPlanTime: BebasUILabel! = {
        let label = BebasUILabel()
        
        label.text = getString("plan_plan")
        label.textAlignment = .center
        label.font = label.font.withSize(56)
        
        return label
    }()
    
    private lazy var viewDistance: UIView! = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickDistance)))
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "distanceIcon")
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints({ (make) in
            make.height.equalTo(self.imageHeight)
        })
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(self.labelPlanDistance)
        stackView.addArrangedSubview(imageView)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var labelPlanDistance: BebasUILabel! = {
        let label = BebasUILabel()
        
        label.text = getString("plan_plan")
        label.textAlignment = .center
        label.font = label.font.withSize(56)
        
        return label
    }()
    
}
