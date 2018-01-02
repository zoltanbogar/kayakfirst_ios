//
//  ViewPlanTypeLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewPlanTypeLayout: BaseLayout {
    
    //MARK: constants
    private let imageHeight: CGFloat = 70
    private let maxTextSize: CGFloat = 56
    
    func initTextHeight(frame: CGRect) {
        let height = frame.height
        
        var textHeight = height / 6
        
        if textHeight > maxTextSize {
            textHeight = maxTextSize
        }
        
        labelPlanDistance.font = labelPlanDistance.font.withSize(textHeight)
        labelPlanTime.font = labelPlanTime.font.withSize(textHeight)
    }
    
    override func setView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(viewTime)
        
        let halfDivider = HalfDivider()
        stackView.addArrangedSubview(halfDivider)
        
        halfDivider.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
        }
        
        stackView.addArrangedSubview(viewDistance)
        
        viewTime.snp.makeConstraints { (make) in
            make.width.equalTo(viewDistance)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var viewTime: UIView! = {
        let view = UIView()
        
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
        
        self.labelPlanTime.snp.makeConstraints({ (make) in
            make.width.equalTo(view.snp.width)
        })
        
        stackView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        return view
    }()
    
    lazy var labelPlanTime: BebasUILabel! = {
        let label = BebasUILabel()
        
        label.text = getString("plan_plan")
        label.textAlignment = .center
        label.font = label.font.withSize(self.maxTextSize)
        
        return label
    }()
    
    lazy var viewDistance: UIView! = {
        let view = UIView()
        
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
        
        self.labelPlanDistance.snp.makeConstraints({ (make) in
            make.width.equalTo(view.snp.width)
        })
        
        stackView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        return view
    }()
    
    lazy var labelPlanDistance: BebasUILabel! = {
        let label = BebasUILabel()
        
        label.text = getString("plan_plan")
        label.textAlignment = .center
        label.font = label.font.withSize(self.maxTextSize)
        
        return label
    }()
    
}
