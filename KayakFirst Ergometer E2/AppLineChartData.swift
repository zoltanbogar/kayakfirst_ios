//
//  LineChartData.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Charts
//TODO: index out of range exception can be
class AppLineChartData {
    
    //MARK: properties
    private var lineChart: LineChartView
    internal var position: Int
    internal var createTrainingList: CreateTrainingList
    private var lineDataSets: [LineChartDataSet]?
    private var label: CalculateEnum?
    private var hasLeftData = false
    private var hasRightData = false
    
    fileprivate var leftYDateFormatHelper = DateFormatHelper()
    
    //MARK: init
    init(lineChart: LineChartView, position: Int, createTrainingList: CreateTrainingList) {
        self.lineChart = lineChart
        self.position = position
        self.createTrainingList = createTrainingList
        
        initChartDesign()
    }
    
    //MARK: abstract functions
    func createEntries(trainingList: [[Training]], label: CalculateEnum) -> [ChartDataEntry] {
        fatalError("Must be implemented")
    }
    func xAxisFormatter() -> IAxisValueFormatter {
        fatalError("Must be implemented")
    }
    
    //MARK: createData
    func createTrainingListByLabel(diagramLabels: [DiagramLabel]) {
        hasLeftData = false
        hasRightData = false
        
        lineDataSets = [LineChartDataSet]()
        
        for l in diagramLabels {
            if l.isActive {
                addData(trainingsList: CalculateEnum.getTrainingListSumByLabel(label: l.getLabel(), createTrainingList: createTrainingList), diagramLabel: l)
            } else {
                label = nil
            }
        }
        refreshChart()
    }
    
    private func initChartDesign() {
        formatXAxis();
        formatYAxis();
        lineChart.chartDescription = nil
        lineChart.legend.enabled = false
        lineChart.noDataText = getString("chart_training_no_value_selected")
        lineChart.noDataTextColor = Colors.colorAccent
        lineChart.doubleTapToZoomEnabled = false
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
        
        lineDataSet.colors = [CalculateEnum.getColor(calculate: diagramLabel.getLabel())]
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.valueTextColor = UIColor.clear
        lineDataSet.lineWidth = chartLineWidth
        lineDataSet.highlightEnabled = false
        
        if diagramLabel.getLabel() == CalculateEnum.T_200 ||
            diagramLabel.getLabel() == CalculateEnum.T_500 ||
            diagramLabel.getLabel() == CalculateEnum.T_1000 {
            lineDataSet.axisDependency = .left
            hasLeftData = true
        } else {
            lineDataSet.axisDependency = .right
            hasRightData = true
        }
        
        setYAxisEnabled()
        
        return lineDataSet
    }
    
    private func formatXAxis() {
        let axis = lineChart.xAxis
        axis.labelPosition = .bottom
        axis.valueFormatter = xAxisFormatter()
        axis.drawGridLinesEnabled = false
        axis.axisLineColor = Colors.colorWhite
        axis.axisLineWidth = chartLineWidth
        axis.labelTextColor = Colors.colorWhite
    }
    
    private func formatYAxis() {
        let leftAxis = lineChart.leftAxis
        let rightAxis = lineChart.rightAxis
        
        leftYDateFormatHelper.format = TimeEnum.timeFormatTwo
        leftAxis.valueFormatter = LeftYAxisFormatter(lineChartData: self)
        rightAxis.valueFormatter = RightYAxisFormatter()
        
        leftAxis.gridColor = Colors.colorInactive
        rightAxis.drawGridLinesEnabled = false
        
        leftAxis.axisLineColor = Colors.colorWhite
        rightAxis.axisLineColor = Colors.colorWhite
        
        leftAxis.axisLineWidth = chartLineWidth
        rightAxis.axisLineWidth = chartLineWidth
        
        leftAxis.labelTextColor = Colors.colorWhite
        rightAxis.labelTextColor = Colors.colorWhite
    }
    
    private func setYAxisEnabled() {
        lineChart.leftAxis.enabled = hasLeftData
        lineChart.rightAxis.enabled = hasRightData
    }
}

class LeftYAxisFormatter: NSObject, IAxisValueFormatter {
    
    private var lineChartData: AppLineChartData
    
    init(lineChartData: AppLineChartData) {
        self.lineChartData = lineChartData
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return lineChartData.leftYDateFormatHelper.getTime(millisec: value)!
    }
}

class RightYAxisFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(format: "%.0f", value)
    }
}
