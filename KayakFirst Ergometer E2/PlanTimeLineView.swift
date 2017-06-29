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
    
    private var originalWidth: CGFloat = 0
    private var lowestVisibleX: Double = 0
    private var highestVisibleX: Double = 0
    
    private var widthConstant: CGFloat = 0
    private var leftConstant: CGFloat = 0
    
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
        originalWidth = frame.width
        
        zoomTimeLine()
    }
    
    override func layoutSubviews() {
        if originalWidth == 0 {
            measureOriginalWidth()
        }
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
    }
    
    private func getPlanElementView(planElement: PlanElement, weight: CGFloat) -> PlanElementTimelineView {
        let view = PlanElementTimelineView(weight: weight)
        view.backgroundColor = getPlanElementColor(planElement: planElement)
        
        return view
    }
    
    //MARK: chart delegate
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        zoomTimeLine()
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        moveTimeLine()
    }
    
    //MARK: zoom timeline
    private func moveTimeLine() {
        if let chart = lineChart {
            if lowestVisibleX == 0 && highestVisibleX == 0 {
                lowestVisibleX = chart.lowestVisibleX
                highestVisibleX = chart.highestVisibleX
            }
            
            if lowestVisibleX != chart.lowestVisibleX && highestVisibleX != chart.highestVisibleX {
                zoomTimeLine()
                
                lowestVisibleX = chart.lowestVisibleX
                highestVisibleX = chart.highestVisibleX
            }
        }
    }
    
    private func zoomTimeLine() {
        if let chart = lineChart {
            let diffZoomX = chart.highestVisibleX - chart.lowestVisibleX
            let scaleX: CGFloat = (CGFloat(plan!.length / diffZoomX))
            
            widthConstant = originalWidth * scaleX
            
            let moveXBase: CGFloat = (originalWidth * scaleX - originalWidth) / 2
            let scaleLayoutX: CGFloat = CGFloat(chart.lineData!.xMax / diffZoomX)
            let leftPercent: CGFloat = CGFloat(chart.lowestVisibleX / chart.lineData!.xMax)
            let moveX = -(leftPercent * originalWidth * scaleLayoutX)
            
            leftConstant = moveXBase + moveX
            
            initConstraints()
        }
    }
    
    private func initConstraints() {
        stackView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview().offset(leftConstant)
            make.width.equalTo(widthConstant)
        }
    }
}
