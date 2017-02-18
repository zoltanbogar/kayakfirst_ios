//
//  LineChartData.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Charts
class AppLineChartData {
    
    //MARK: properties
    private var lineChart: LineChartView
    internal var position: Int
    private var createTrainingList: CreateTrainingList
    private var lineDataSets: [LineChartDataSet]?
    private var label: CalculateEnum?
    
    //MARK: init
    init(lineChart: LineChartView, position: Int, createTrainingList: CreateTrainingList) {
        self.lineChart = lineChart
        self.position = position
        self.createTrainingList = createTrainingList
    }
    
    //MARK: abstract functions
    func createEntries(trainingList: [[Training]], label: CalculateEnum) -> [ChartDataEntry] {
        fatalError("Must be implemented")
    }
    
    //MARK: createData
    func createTrainingListByLabel(diagramLabels: [DiagramLabel]) {
        lineDataSets = [LineChartDataSet]()
        
        for l in diagramLabels {
            if l.isActive {
                addData(trainingsList: CalculateEnum.getTrainingListSumByLabel(diagramLabel: l, createTrainingList: createTrainingList), diagramLabel: l)
            } else {
                label = nil
            }
        }
        refreshChart()
    }
    
    private func addData(trainingsList: [[Training]], diagramLabel: DiagramLabel) {
        lineDataSets?.append(createLineDataSet(entries: createEntries(trainingList: trainingsList, label: diagramLabel.getLabel()), diagramLabel: diagramLabel))
    }
    
    private func refreshChart() {
        var dataSets = [LineChartDataSet]()
        
        for lineDataSet in lineDataSets! {
            dataSets.append(lineDataSet)
        }
        
        var lineData: LineChartData?
        
        if dataSets.count == 0 {
            lineData = nil
        } else {
            lineData = LineChartData(dataSets: dataSets)
        }
        
        lineChart.data = lineData
    }
    
    private func createLineDataSet(entries: [ChartDataEntry]?, diagramLabel: DiagramLabel) -> LineChartDataSet {
        let lineDataSet = LineChartDataSet(values: entries, label: diagramLabel.getLabel().rawValue)
        
        if diagramLabel.getLabel() == CalculateEnum.T_200 ||
            diagramLabel.getLabel() == CalculateEnum.T_500 ||
            diagramLabel.getLabel() == CalculateEnum.T_1000 {
            lineDataSet.axisDependency = .left
        } else {
            lineDataSet.axisDependency = .right
        }
        
        return lineDataSet
    }
    
}
