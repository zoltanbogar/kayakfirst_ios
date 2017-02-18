//
//  ChartView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import Charts

//MARK: time enum
enum ChartMode: String {
    case chartModeTime = "time"
    case chartModeDistance = "distance"
}

class ChartView: UIView {
    
    //MARK: properties
    private var position: Int?
    private var createTrainingList: CreateTrainingList?
    private var lineChartData: AppLineChartData?
    private var diagramLabelList: [DiagramLabel]?
    
    //MARK: init
    init(position: Int, createTrainingList: CreateTrainingList) {
        super.init(frame: CGRect.zero)
        
        self.position = position
        self.createTrainingList = createTrainingList
        
        initView()
        initLabelList()
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLabelList() {
        diagramLabelList = [labelT200, labelT500, labelT1000, labelStrokes, labelForce, labelSpeed]
    }
    
    private func initChart() {
        lineChartData = LineChartTime(lineChart: lineChart, position: position!, createTrainingList: createTrainingList!)
        refreshChart()
    }
    
    private func refreshChart() {
        lineChartData?.createTrainingListByLabel(diagramLabels: diagramLabelList!)
    }
    
    //MARK: views
    private func initView() {
        let stackViewL = UIStackView()
        stackViewL.axis = .horizontal
        stackViewL.distribution = .fillEqually
        stackViewL.addArrangedSubview(labelT200)
        stackViewL.addArrangedSubview(labelT500)
        stackViewL.addArrangedSubview(labelT1000)
        
        let stackViewR = UIStackView()
        stackViewR.axis = .horizontal
        stackViewR.distribution = .fillEqually
        stackViewR.addArrangedSubview(labelStrokes)
        stackViewR.addArrangedSubview(labelForce)
        stackViewR.addArrangedSubview(labelSpeed)
        
        let stackViewLabels = UIStackView()
        stackViewLabels.axis = .vertical
        stackViewLabels.distribution = .fillEqually
        stackViewLabels.addArrangedSubview(stackViewL)
        stackViewLabels.addArrangedSubview(stackViewR)
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(stackViewLabels)
        mainStackView.addArrangedSubview(lineChart)
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private lazy var lineChart: LineChartView! = {
        let chart = LineChartView()
        
        return chart
    }()
    
    private lazy var labelT200: LabelT200! = {
        let label = LabelT200()
        
        label.labelSelectedListener = self.labelT200Listener
        
        return label
    }()
    
    private lazy var labelT500: LabelT500! = {
        let label = LabelT500()
        
        label.labelSelectedListener = self.labelT500Listener
        
        return label
    }()
    
    private lazy var labelT1000: LabelT1000! = {
        let label = LabelT1000()
        
        label.labelSelectedListener = self.labelT1000Listener
        
        return label
    }()
    
    private lazy var labelStrokes: LabelStroke! = {
        let label = LabelStroke()
        
        label.labelSelectedListener = self.labelListener
        
        return label
    }()
    
    private lazy var labelForce: LabelForce! = {
        let label = LabelForce()
        
        label.labelSelectedListener = self.labelListener
        
        return label
    }()
    
    private lazy var labelSpeed: LabelSpeed! = {
        let label = LabelSpeed()
        
        label.labelSelectedListener = self.labelListener
        
        return label
    }()
    
    //MARK: listeners
    private func labelT200Listener(_ label: DiagramLabel) {
        labelT200.isActive = true
        labelT500.isActive = false
        labelT1000.isActive = false
        refreshChart()
    }
    
    private func labelT500Listener(_ label: DiagramLabel) {
        labelT200.isActive = false
        labelT500.isActive = true
        labelT1000.isActive = false
        refreshChart()
    }
    
    private func labelT1000Listener(_ label: DiagramLabel) {
        labelT200.isActive = false
        labelT500.isActive = false
        labelT1000.isActive = true
        refreshChart()
    }
    
    private func labelListener(_ label: DiagramLabel) {
        refreshChart()
    }
    
}
