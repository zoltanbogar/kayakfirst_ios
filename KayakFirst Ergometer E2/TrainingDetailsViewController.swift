//
//  TrainingDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class TrainingDetailsViewController: BaseVC<VcTrainingDetailsLayout> {
    
    //MARK: properties
    var sumTraining: SumTraining?
    var titleString: String? {
        get {
            let timeStamp = sumTraining!.startTime
            let titleString = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateTimeFormat, timeIntervallSince1970: timeStamp)
            return titleString
        }
    }
    var position: Int = 0
    var maxPosition: Int = 0
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
        
        tabPosition = 0
    }

    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout?.btnTable.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        contentLayout?.btnTimeChart.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        contentLayout?.btnDistanceChart.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        
        contentLayout?.labelDuration.text = sumTraining?.formattedDuration
        contentLayout?.labelDistance.text = sumTraining?.formattedDistance
    }
    
    override func getContentLayout(contentView: UIView) -> VcTrainingDetailsLayout {
        return VcTrainingDetailsLayout(contentView: contentView, position: position)
    }
    
    //MARK: callbacks
    private func setTabPosition() {
        contentLayout!.setTabPosition(tabPosition: tabPosition)
    }
    
    @objc private func handleTabClick(sender: UIButton) {
        if sender == contentLayout!.btnTable {
            tabPosition = 0
        } else if sender == contentLayout!.btnTimeChart {
            tabPosition = 1
        } else if sender == contentLayout!.btnDistanceChart {
            tabPosition = 2
        }
    }
}
