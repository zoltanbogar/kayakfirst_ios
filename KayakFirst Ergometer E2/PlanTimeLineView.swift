//
//  PlanTimeLineView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Charts

class PlanTimeLineView: UIView, ChartViewDelegate {
    
    //MARK: properties
    private var plan: Plan?
    private var lineChart: LineChartView?
    
    private var stackView = UIStackView()
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height:  timeLineHeight)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        measureOriginalWidth()
    }
    
    //MARK: functions
    func setData(plan: Plan, lineChart: LineChartView) {
        self.plan = plan
        self.lineChart = lineChart
        self.lineChart?.delegate = self
        initPlanElements()
    }
    
    //MARK: init view
    private func initView() {
        //TODO
    }
    
    func measureOriginalWidth() {
        
    }
    
    private func initPlanElements() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        if let planElements = plan?.planElements {
            
            let length = plan?.length
            
            for planElement in planElements {
                let weight = CGFloat(planElement.value) / CGFloat(length!)
                
                stackView.addArrangedSubview(getPlanElementView(planElement: planElement, weight: weight))
                
            }
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        measureOriginalWidth()
    }
    
    private func getPlanElementView(planElement: PlanElement, weight: CGFloat) -> PlanElementTimelineView {
        let view = PlanElementTimelineView(weight: weight)
        view.backgroundColor = getPlanElementColor(planElement: planElement)
        
        return view
    }
}
