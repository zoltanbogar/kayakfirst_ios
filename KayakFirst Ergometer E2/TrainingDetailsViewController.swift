//
//  TrainingDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class TrainingDetailsViewController: UIViewController {
    
    //MARK: constants
    private let segmentItems = [getString("training_details_all"), getString("training_diagram_time"), getString("training_diagram_distance")]
    
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
    var position: Int?
    var createTrainingList: CreateTrainingList?
    
    //MARK: views
    private let stackView = UIStackView()
    private let viewTop = UIView()
    private let viewBottom = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUi()
    }
    
    override func viewDidLayoutSubviews() {
        //viewBottom.setNeedsLayout()
        //viewBottom.layoutIfNeeded()
    }
    
    private func initUi() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        viewTop.backgroundColor = Colors.colorAccent
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(getNavigationBarHeight(viewController: self), 0, 0, 0))
        }
        stackView.addArrangedSubview(viewTop)
        stackView.addArrangedSubview(viewBottom)
        
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
    
    //MARK: views
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
            viewSub = TrainingSumView(frame: viewBottom.bounds, position: position!, createTrainingList: createTrainingList!)
        }
        
        viewBottom.removeAllSubviews()
        viewBottom.addSubview(viewSub)
    }
}
