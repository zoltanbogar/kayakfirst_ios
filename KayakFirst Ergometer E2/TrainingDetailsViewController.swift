//
//  TrainingDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class TrainingDetailsViewController: BaseVC {
    
    //MARK: constants
    private let segmentItems = [getString("training_details_all"), getString("training_diagram_time"), getString("training_diagram_distance")]
    
    //MARK: properties
    var sumTraining: SumTraining? {
        didSet {
            labelStart.text = sumTraining?.formattedStartTime
            labelDuration.text = sumTraining?.formattedDuration
            labelDistance.text = sumTraining?.formattedDistance
        }
    }
    var position: Int?
    var createTrainingList: CreateTrainingList?
    
    //MARK: views
    private let viewTop = UIView()
    private let viewBottom = UIView()
    
    //MARK: views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        viewTop.backgroundColor = Colors.colorAccent
        
        stackView.addArrangedSubview(viewTop)
        stackView.addArrangedSubview(viewBottom)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        viewTop.addSubview(labelStart)
        labelStart.snp.makeConstraints { make in
            make.top.equalTo(viewTop)
            make.left.equalTo(viewTop)
        }
        viewTop.addSubview(labelDuration)
        labelDuration.snp.makeConstraints { make in
            make.top.equalTo(labelStart.snp.bottom)
            make.left.equalTo(labelStart)
        }
        viewTop.addSubview(labelDistance)
        labelDistance.snp.makeConstraints { make in
            make.top.equalTo(labelDuration.snp.bottom)
            make.left.equalTo(labelStart)
        }
        viewTop.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalTo(viewTop)
            make.bottom.equalTo(viewTop)
        }
    }
    
    private lazy var segmentedControl: UISegmentedControl! = {
        let control = UISegmentedControl(items: self.segmentItems)
        control.tintColor = Colors.colorPrimary
        control.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
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
    
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 1:
            //TODO
            viewSub = UIView(frame: viewBottom.bounds)
            viewSub.backgroundColor = Colors.colorT
        case 2:
            //TODO
            viewSub = UIView(frame: viewBottom.bounds)
            viewSub.backgroundColor = Colors.colorBluetooth
        default:
            viewSub = TrainingSumView(frame: CGRect.zero, position: position!, createTrainingList: createTrainingList!)
        }
        
        viewBottom.removeAllSubviews()
        viewBottom.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(viewBottom)
        }
    }
}
