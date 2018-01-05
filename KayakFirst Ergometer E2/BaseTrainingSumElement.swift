//
//  BaseTrainingSumElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class BaseTrainingSumElement: UIView {
    
    //MARK: properties
    var trainingList: [Training]?
    var sumTraining: SumTraining!
    
    //MARK: init
    init(sumTraining: SumTraining) {
        self.sumTraining = sumTraining
        
        super.init(frame: CGRect.zero)

        initView()
        initTrainingList()
        
        run()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            let height = labelTitle.intrinsicContentSize.height + labelValue.intrinsicContentSize.height
            return CGSize(width: 0, height: height)
        }
    }
    
    //MARK: other
    func run() {
        if isMetric() {
            labelTitle.text = getTitleMetric()
        } else {
            labelTitle.text = getTitleImperial()
        }
        labelValue.text = getFormattedValue(value: calculate())
    }
    
    private func initTrainingList() {
        trainingList = getTrainingList()
    }
    
    //MARK: views
    private func initView() {
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        addSubview(labelValue)
        labelValue.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom)
            make.centerX.equalTo(self)
        }
    }
    
    private lazy var labelTitle: AppUILabel! = {
        let label = AppUILabel()
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var labelValue: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "BebasNeue", size: 30)
        
        return label
    }()
    
    //MARK: abstract functions
    func getTrainingList() -> [Training] {
        fatalError("Must be implemented")
    }
    
    func getTitleMetric() -> String {
        fatalError("Must be implemented")
    }
    
    func getTitleImperial() -> String {
        fatalError("Must be implemented")
    }
    
    func isMetric() -> Bool {
        fatalError("Must be implemented")
    }
    
    func getFormattedValue(value: Double) -> String {
        fatalError("Must be implemented")
    }
    
    func calculate() -> Double {
        fatalError("Must be implemented")
    }
}
