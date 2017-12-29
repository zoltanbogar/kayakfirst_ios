//
//  VcTrainingDetailsLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcTrainingDetailsLayout: BaseLayout {
    
    private let viewTop = UIView()
    private let viewBottom = UIView()
    
    private var stackView: UIStackView?
    private var stackViewTitle: UIStackView?
    
    private let position: Int
    
    init(contentView: UIView, position: Int) {
        self.position = position
        
        super.init(contentView: contentView)
    }
    
    //MARK: functions
    func setTabPosition(tabPosition: Int) {
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
    
    override func setView() {
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
        stackViewVertical1.spacing = margin05
        stackViewVertical1.addArrangedSubview(labelDurationTitle)
        stackViewVertical1.addArrangedSubview(labelDuration)
        
        let stackViewVertical2 = UIStackView()
        stackViewVertical2.axis = .vertical
        stackViewVertical2.spacing = margin05
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
        
        contentView.addSubview(stackView!)
        stackView?.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin05, 0))
        }
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
            make.height.equalTo(250)
            make.width.equalTo(250)
        }
    }
    
    //MARK: view
    lazy var btnTable: UIButton! = {
        let button = UIButton()
        button.setTitle(getString("training_details_all").uppercased(),for: .normal)
        button.backgroundColor = Colors.colorPrimary
        button.setTitleColor(Colors.colorWhite, for: UIControlState.normal)
        
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        return button
    }()
    
    lazy var btnTimeChart: UIButton! = {
        let button = UIButton()
        button.setTitle(getString("training_diagram_time").uppercased(),for: .normal)
        button.backgroundColor = Colors.colorPrimary
        button.setTitleColor(Colors.colorWhite, for: UIControlState.normal)
        
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        return button
    }()
    
    lazy var btnDistanceChart: UIButton! = {
        let button = UIButton()
        button.setTitle(getString("training_diagram_distance").uppercased(),for: .normal)
        button.backgroundColor = Colors.colorPrimary
        button.setTitleColor(Colors.colorWhite, for: UIControlState.normal)
        
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        return button
    }()
    
    lazy var labelDurationTitle: AppUILabel! = {
        let label = AppUILabel()
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        label.text = getString("training_duration").uppercased()
        
        return label
    }()
    
    lazy var labelDistanceTitle: AppUILabel! = {
        let label = AppUILabel()
        label.font = label.font.withSize(12)
        label.textAlignment = .center
        label.text = getString("training_distance").uppercased()
        
        return label
    }()
    
    lazy var labelDuration: UILabel! = {
        let label = LabelWithAdaptiveTextHeight()
        label.textColor = Colors.colorWhite
        label.textAlignment = .center
        label.font = UIFont(name: "BebasNeue", size: 40)
        
        return label
    }()
    
    lazy var labelDistance: UILabel! = {
        let label = LabelWithAdaptiveTextHeight()
        label.textColor = Colors.colorWhite
        label.textAlignment = .center
        label.font = UIFont(name: "BebasNeue", size: 40)
        
        return label
    }()
    
    lazy var sumTrainingView: TrainingSumView! = {
        let view = TrainingSumView(frame: CGRect.zero, position: self.position)
        
        return view
    }()
    
    lazy var chartTime: ChartView! = {
        let view = ChartView(position: self.position, chartMode: ChartMode.chartModeTime)
        
        return view
    }()
    
    lazy var chartDistance: ChartView! = {
        let view = ChartView(position: self.position, chartMode: ChartMode.chartModeDistance)
        
        return view
    }()
    
}
