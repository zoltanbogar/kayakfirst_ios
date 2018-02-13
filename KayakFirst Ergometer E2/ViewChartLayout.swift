//
//  ViewChartLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Charts

class ViewChartLayout: BaseLayout {
    
    override func setView() {
        let stackViewL = UIStackView()
        stackViewL.axis = .horizontal
        stackViewL.distribution = .fillEqually
        stackViewL.spacing = margin05
        stackViewL.addArrangedSubview(labelT200)
        stackViewL.addArrangedSubview(labelT500)
        stackViewL.addArrangedSubview(labelT1000)
        
        let stackViewR = UIStackView()
        stackViewR.axis = .horizontal
        stackViewR.distribution = .fillEqually
        stackViewR.spacing = margin
        stackViewR.addArrangedSubview(labelStrokes)
        stackViewR.addArrangedSubview(labelSpeed)
        stackViewR.addArrangedSubview(labelForce)
        
        let stackViewLabels = UIStackView()
        stackViewLabels.axis = .vertical
        stackViewLabels.distribution = .fillEqually
        stackViewLabels.spacing = margin
        stackViewLabels.addArrangedSubview(stackViewL)
        stackViewLabels.addArrangedSubview(stackViewR)
        
        let viewLabels = UIView()
        viewLabels.addSubview(stackViewLabels)
        stackViewLabels.snp.makeConstraints { (make) in
            make.edges.equalTo(viewLabels).inset(UIEdgeInsetsMake(0, margin, 0, margin))
        }
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = margin05
        mainStackView.addArrangedSubview(viewLabels)
        mainStackView.addArrangedSubview(lineChart)
        mainStackView.addArrangedSubview(planView)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        planView.snp.makeConstraints { (make) in
            make.left.equalTo(lineChart).offset(margin2)
            make.right.equalTo(lineChart).offset(-margin)
        }
        
        contentView.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    lazy var progressBar: AppProgressBar! = {
        let progressBar = AppProgressBar()
        
        return progressBar
    }()
    
    lazy var planView: PlanTimeLineView! = {
        let view = PlanTimeLineView()
        
        return view
    }()
    
    lazy var lineChart: LineChartView! = {
        let chart = LineChartView()
        
        return chart
    }()
    
    lazy var labelT200: LabelT200! = {
        let label = LabelT200()
        
        return label
    }()
    
    lazy var labelT500: LabelT500! = {
        let label = LabelT500()
        
        return label
    }()
    
    lazy var labelT1000: LabelT1000! = {
        let label = LabelT1000()
        
        return label
    }()
    
    lazy var labelStrokes: LabelStroke! = {
        let label = LabelStroke()
        
        return label
    }()
    
    lazy var labelForce: LabelForce! = {
        let label = LabelForce()
        
        return label
    }()
    
    lazy var labelSpeed: LabelSpeed! = {
        let label = LabelSpeed()
        
        return label
    }()
    
}
