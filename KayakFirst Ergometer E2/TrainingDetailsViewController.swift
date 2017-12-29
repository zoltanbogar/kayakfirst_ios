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
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        (contentLayout as! VcTrainingDetailsLayout).btnTable.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        (contentLayout as! VcTrainingDetailsLayout).btnTimeChart.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        (contentLayout as! VcTrainingDetailsLayout).btnDistanceChart.addTarget(self, action: #selector(self.handleTabClick(sender:)), for: .touchUpInside)
        
        (contentLayout as! VcTrainingDetailsLayout).labelDuration.text = sumTraining?.formattedDuration
        (contentLayout as! VcTrainingDetailsLayout).labelDistance.text = sumTraining?.formattedDistance
    }
    
    override func getContentLayout(contentView: UIView) -> VcTrainingDetailsLayout {
        return VcTrainingDetailsLayout(contentView: contentView, position: position)
    }
    
    //MARK: callbacks
    private func setTabPosition() {
        (contentLayout as! VcTrainingDetailsLayout).setTabPosition(tabPosition: tabPosition)
    }
    
    @objc private func handleTabClick(sender: UIButton) {
        if sender == (contentLayout as! VcTrainingDetailsLayout).btnTable {
            tabPosition = 0
        } else if sender == (contentLayout as! VcTrainingDetailsLayout).btnTimeChart {
            tabPosition = 1
        } else if sender == (contentLayout as! VcTrainingDetailsLayout).btnDistanceChart {
            tabPosition = 2
        }
    }
}
