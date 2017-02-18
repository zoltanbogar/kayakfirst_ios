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
    var position: Int = 0
    var maxPosition: Int = 0
    var createTrainingList: CreateTrainingList?
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initArrows()
    }
    
    private func initArrows() {
        if maxPosition == 1 {
            imgArrowLeft.isHidden = true
            imgArrowRight.isHidden = true
        } else {
            if position == 0 {
                imgArrowLeft.isHidden = true
                imgArrowRight.isHidden = false
            } else if position == maxPosition - 1 {
                imgArrowLeft.isHidden = false
                imgArrowRight.isHidden = true
            } else {
                imgArrowLeft.isHidden = false
                imgArrowRight.isHidden = false
            }
        }
    }
    
    //MARK: views
    private let viewTop = UIView()
    private let viewBottom = UIView()
    
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        //stackView.distribution = .fillEqually
        viewTop.backgroundColor = Colors.colorAccent
        
        stackView.addArrangedSubview(viewTop)
        stackView.addArrangedSubview(viewBottom)
        
        let stackViewTop1 = UIStackView()
        stackViewTop1.axis = .vertical
        stackViewTop1.distribution = .fillEqually
        stackViewTop1.spacing = margin05
        
        let stackViewStart = UIStackView()
        stackViewStart.axis = .horizontal
        stackViewStart.addArrangedSubview(labelStartTitle)
        stackViewStart.addArrangedSubview(labelStart)
        stackViewStart.addHorizontalSpacing()
        
        let stackViewDuration = UIStackView()
        stackViewDuration.axis = .horizontal
        stackViewDuration.addArrangedSubview(labelDurationTitle)
        stackViewDuration.addArrangedSubview(labelDuration)
        stackViewDuration.addHorizontalSpacing()
        
        let stackViewDistance = UIStackView()
        stackViewDistance.axis = .horizontal
        stackViewDistance.addArrangedSubview(labelDistanceTitle)
        stackViewDistance.addArrangedSubview(labelDistance)
        stackViewDistance.addHorizontalSpacing()
        
        stackViewTop1.addArrangedSubview(stackViewStart)
        stackViewTop1.addArrangedSubview(stackViewDuration)
        stackViewTop1.addArrangedSubview(stackViewDistance)
        
        let stackViewTop2 = UIStackView()
        stackViewTop2.axis = .vertical
        stackViewTop2.spacing = margin05
        
        stackViewTop2.addArrangedSubview(stackViewTop1)
        stackViewTop2.addArrangedSubview(segmentedControl)
        
        viewTop.addSubview(stackViewTop2)
        stackViewTop2.snp.makeConstraints { make in
            make.edges.equalTo(viewTop).inset(UIEdgeInsetsMake(margin, margin, margin, margin))
        }
        
        viewTop.addSubview(imgArrowLeft)
        imgArrowLeft.snp.makeConstraints { make in
            make.centerY.equalTo(viewTop)
        }
        viewTop.addSubview(imgArrowRight)
        imgArrowRight.snp.makeConstraints { make in
            make.centerY.equalTo(viewTop)
            make.right.equalTo(viewTop)
        }
        
        viewBottom.addSubview(sumTrainingView)
        sumTrainingView.snp.makeConstraints { make in
            make.edges.equalTo(viewBottom)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    private lazy var segmentedControl: UISegmentedControl! = {
        let control = UISegmentedControl(items: self.segmentItems)
        control.tintColor = Colors.colorPrimary
        control.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    private lazy var labelStartTitle: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_start")
        
        return label
    }()
    
    private lazy var labelDurationTitle: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_duration")
        
        return label
    }()
    
    private lazy var labelDistanceTitle: AppUILabel! = {
        let label = AppUILabel()
        label.text = getString("training_distance")
        
        return label
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
    
    private lazy var sumTrainingView: TrainingSumView! = {
        let view = TrainingSumView(frame: CGRect.zero, position: self.position, createTrainingList: self.createTrainingList!)
        
        return view
    }()
    
    private lazy var chartTime: ChartView! = {
        let view = ChartView(position: self.position, createTrainingList: self.createTrainingList!)
        
        return view
    }()
    
    private lazy var imgArrowLeft: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_keyboard_arrow_left_white")
        
        return imageView
    }()
    
    private lazy var imgArrowRight: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_keyboard_arrow_right_white")
        
        return imageView
    }()
    
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 1:
            viewSub = chartTime
        case 2:
            //TODO
            viewSub = UIView(frame: viewBottom.bounds)
            viewSub.backgroundColor = Colors.colorBluetooth
        default:
            viewSub = sumTrainingView
        }
        
        viewBottom.removeAllSubviews()
        viewBottom.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(viewBottom)
        }
    }
}
