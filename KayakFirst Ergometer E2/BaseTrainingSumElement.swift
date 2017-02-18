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
    var position: Int?
    var createTrainingList: CreateTrainingList?
    
    //MARK: init
    init(position: Int, createTrainingList: CreateTrainingList) {
        super.init(frame: CGRect.zero)
        self.position = position
        self.createTrainingList = createTrainingList

        initView()
        initTrainingList()
        
        run()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: other
    func run() {
        labelTitle.text = getTitle()
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
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var labelValue: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.textColor = Colors.colorAccent
        
        return label
    }()
    
    //MARK: abstract functions
    func getTrainingList() -> [Training] {
        fatalError("Must be implemented")
    }
    
    func getTitle() -> String {
        fatalError("Must be implemented")
    }
    
    func getFormattedValue(value: Double) -> String {
        fatalError("Must be implemented")
    }
    
    func getUnit() -> String {
        fatalError("Must be implemented")
    }
    
    func calculate() -> Double {
        fatalError("Must be implemented")
    }
}
