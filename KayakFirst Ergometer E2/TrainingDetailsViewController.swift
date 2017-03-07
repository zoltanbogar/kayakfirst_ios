//
//  TrainingDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class TrainingDetailsViewController: BaseVC {
    
    //MARK: properties
    var sumTraining: SumTraining? {
        didSet {
            labelDuration.text = sumTraining?.formattedDuration
            labelDistance.text = sumTraining?.formattedDistance
            initTitle()
        }
    }
    var position: Int = 0
    var maxPosition: Int = 0
    private var stackView: UIStackView?
    private var stackViewTitle: UIStackView?
    private var _tabPosition = 0
    private var tabPosition: Int {
        get {
            return _tabPosition
        }
        set {
            _tabPosition = newValue
            setTabPosition()
        }
    }
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initArrows()
        tabPosition = 0
    }
    
    //TODO: delet arrows
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
    
    private func initTitle() {
        let timeStamp = sumTraining!.startTime
        let titleString = DateFormatHelper.getDate(dateFormat: getString("date_time_format"), timeIntervallSince1970: timeStamp)
        //TODO: not works!!
        self.parent?.navigationController?.navigationItem.title = titleString
    }

    //MARK: init view
    private let viewTop = UIView()
    private let viewBottom = UIView()
    
    override func initView() {
        stackView = UIStackView()
        stackView?.axis = .vertical
        stackView?.spacing = margin05
        
        stackView?.addArrangedSubview(viewTop)
        stackView?.addArrangedSubview(viewBottom)
        
        stackViewTitle = UIStackView()
        stackViewTitle?.axis = .horizontal
        stackViewTitle?.distribution = .fillEqually
        
        let stackViewVertical1 = UIStackView()
        stackViewVertical1.axis = .vertical
        stackViewVertical1.addArrangedSubview(labelDurationTitle)
        stackViewVertical1.addArrangedSubview(labelDuration)
        
        let stackViewVertical2 = UIStackView()
        stackViewVertical2.axis = .vertical
        stackViewVertical2.addArrangedSubview(labelDistanceTitle)
        stackViewVertical2.addArrangedSubview(labelDistance)
        
        stackViewTitle?.addArrangedSubview(stackViewVertical1)
        stackViewTitle?.addArrangedSubview(stackViewVertical2)
        
        let stackViewTab = UIStackView()
        stackViewTab.axis = .horizontal
        stackViewTab.distribution = .fillEqually
        stackViewTab.spacing = dashboardDividerWidth
        stackViewTab.addArrangedSubview(btnTable)
        stackViewTab.addArrangedSubview(btnTimeChart)
        stackViewTab.addArrangedSubview(btnDistanceChart)
        
        let stackViewTabBackground = UIView()
        stackViewTabBackground.backgroundColor = Colors.colorDashBoardDivider
        stackViewTabBackground.addSubview(stackViewTab)
        stackViewTab.snp.makeConstraints { (make) in
            make.edges.equalTo(stackViewTabBackground)
        }
        
        let stackViewTop = UIStackView()
        stackViewTop.axis = .vertical
        stackViewTop.spacing = margin05
        
        let divier1 = UIView()
        divier1.backgroundColor = Colors.colorDashBoardDivider
        divier1.snp.makeConstraints { (make) in
            make.height.equalTo(dashboardDividerWidth)
        }
        
        let divier2 = UIView()
        divier2.backgroundColor = Colors.colorDashBoardDivider
        divier2.snp.makeConstraints { (make) in
            make.height.equalTo(dashboardDividerWidth)
        }
        
        stackViewTop.addVerticalSpacing()
        stackViewTop.addArrangedSubview(stackViewTitle!)
        stackViewTop.addVerticalSpacing()
        stackViewTop.addArrangedSubview(divier1)
        stackViewTop.addArrangedSubview(stackViewTabBackground)
        stackViewTop.addArrangedSubview(divier2)
        
        viewTop.removeAllSubviews()
        
        viewTop.addSubview(stackViewTop)
        stackViewTop.snp.makeConstraints { make in
            make.edges.equalTo(viewTop)
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
        
        contentView.addSubview(stackView!)
        stackView?.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    //TODO: title, TrainingEnvironmentType indicator
    override func initTabBarItems() {
        self.navigationController!.navigationItem.setRightBarButtonItems([btnType], animated: true)
        //self.navigationItem.setRightBarButtonItems([btnType], animated: true)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        stackView?.axis = .vertical
        stackViewTitle?.axis = .horizontal
        viewTop.snp.removeConstraints()
        viewTop.snp.makeConstraints { (make) in
            make.height.equalTo(150)
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        stackView?.axis = .horizontal
        stackViewTitle?.axis = .vertical
        viewTop.snp.removeConstraints()
        viewTop.snp.makeConstraints { (make) in
            make.width.equalTo(250)
        }
    }
    
    //MARK: view
    private lazy var btnType: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "sun")
        
        return button
    }()
    
    private lazy var btnTable: UIButton! = {
        let button = UIButton()
        button.setTitle(getString("training_details_all").uppercased(),for: .normal)
        button.backgroundColor = Colors.colorPrimary
        button.setTitleColor(Colors.colorWhite, for: UIControlState.normal)
        
        button.titleLabel!.font = button.titleLabel!.font.withSize(12)
        
        button.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnTimeChart: UIButton! = {
        let button = UIButton()
        button.setTitle(getString("training_diagram_time").uppercased(),for: .normal)
        button.backgroundColor = Colors.colorPrimary
        button.setTitleColor(Colors.colorWhite, for: UIControlState.normal)
        
        button.titleLabel!.font = button.titleLabel!.font.withSize(12)
        
        button.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnDistanceChart: UIButton! = {
        let button = UIButton()
        button.setTitle(getString("training_diagram_distance").uppercased(),for: .normal)
        button.backgroundColor = Colors.colorPrimary
        button.setTitleColor(Colors.colorWhite, for: UIControlState.normal)
        
        button.titleLabel!.font = button.titleLabel!.font.withSize(12)
        
        button.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelDurationTitle: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.text = getString("training_duration").uppercased()
        
        return label
    }()
    
    private lazy var labelDistanceTitle: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.text = getString("training_distance").uppercased()
        
        return label
    }()
    
    private lazy var labelDuration: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var labelDistance: AppUILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var sumTrainingView: TrainingSumView! = {
        let view = TrainingSumView(frame: CGRect.zero, position: self.position)
        
        return view
    }()
    
    private lazy var chartTime: ChartView! = {
        let view = ChartView(position: self.position, chartMode: ChartMode.chartModeTime)
        
        return view
    }()
    
    private lazy var chartDistance: ChartView! = {
        let view = ChartView(position: self.position, chartMode: ChartMode.chartModeDistance)
        
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
    
    //MARK: callbacks
    private func setTabPosition() {
        btnTable.setTitleColor(Colors.colorWhite, for: .normal)
        btnTimeChart.setTitleColor(Colors.colorWhite, for: .normal)
        btnDistanceChart.setTitleColor(Colors.colorWhite, for: .normal)
        
        let viewSub: UIView
        switch tabPosition {
        case 1:
            viewSub = chartTime
            btnTimeChart.setTitleColor(Colors.colorAccent, for: .normal)
        case 2:
            viewSub = chartDistance
            btnDistanceChart.setTitleColor(Colors.colorAccent, for: .normal)
        default:
            viewSub = sumTrainingView
            btnTable.setTitleColor(Colors.colorAccent, for: .normal)
        }
        
        viewBottom.removeAllSubviews()
        viewBottom.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(viewBottom)
        }
    }
    
    @objc private func handleTabClick(sender: UIButton) {
        if sender == btnTable {
            tabPosition = 0
        } else if sender == btnTimeChart {
            tabPosition = 1
        } else if sender == btnDistanceChart {
            tabPosition = 2
        }
    }
}
