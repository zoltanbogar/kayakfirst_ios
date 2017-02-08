//
//  TrainingDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class TrainingDetailsViewController: UIViewController {
    
    //MARK: properties
    private var _sumTraining: SumTraining?
    var sumTraining: SumTraining? {
        get {
            return _sumTraining
        }
        set {
            _sumTraining = newValue
            
            labelStart.text = _sumTraining?.formattedStartTime
            labelDuration.text = _sumTraining?.formattedDuration
            labelDistance.text = sumTraining?.formattedDistance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUi()
    }
    
    private func initUi() {
        view.addSubview(labelStart)
        labelStart.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        view.addSubview(labelDuration)
        labelDuration.snp.makeConstraints { make in
            make.top.equalTo(labelStart.snp.bottom)
            make.left.equalTo(labelStart)
        }
        view.addSubview(labelDistance)
        labelDistance.snp.makeConstraints { make in
            make.top.equalTo(labelDuration.snp.bottom)
            make.left.equalTo(labelStart)
        }
    }
    
    //MARK: views
    private lazy var labelStart: AppUILabel! = {
        let label = AppUILabel()
        
        return label
    }()
    
    private lazy var labelDuration: AppUILabel! = {
        let label = AppUILabel()
        
        return label
    }()
    
    private lazy var labelDistance: AppUILabel! = {
        let label = AppUILabel()
        
        return label
    }()
}
