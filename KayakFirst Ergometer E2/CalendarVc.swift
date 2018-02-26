//
//  CalendarVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class CalendarVc: BaseVC<VcCalendarLayout> {
    
    //MARK: constants
    private static let modeEvent = "mode_event"
    private static let modeTraining = "mode_training"
    
    //MARK: properties
    private var trainingDataHelper: CalendarTrainingDataHelper?
    private var eventDataHelper: CalendarEventDataHelper?
    
    private var error: Responses?
    private var mode = CalendarVc.modeEvent
    var shouldRefresh = false
    
    //MARK: lifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == CalendarVc.modeEvent || shouldRefresh {
            shouldRefresh = false
             refreshContentWithMode()
        }
        
        WindowHelper.keepScreenOn(isOn: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        WindowHelper.keepScreenOn(isOn: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshCalendarDesign()
    }
    
    internal override func initView() {
        super.initView()
        
        contentLayout!.segmentedControl.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        contentLayout!.btnToday.target = self
        contentLayout!.btnToday.action = #selector(btnTodayClick)
        
        contentLayout!.btnAdd.target = self
        contentLayout!.btnAdd.action = #selector(addClick)
        
        trainingDataHelper = CalendarTrainingDataHelper(calendarVc: self, calendarView: contentLayout!.calendarView, listView: contentLayout!.trainingListView, clickCallback: trainingClick)
        eventDataHelper = CalendarEventDataHelper(calendarVc: self, calendarView: contentLayout!.calendarView, listView: contentLayout!.eventListView, clickCallback: eventClick)
        
        contentLayout!.segmentedControl.selectedSegmentIndex = 0
        setSegmentedItem(sender: contentLayout!.segmentedControl)
    }
    
    override func getContentLayout(contentView: UIView) -> VcCalendarLayout {
        return VcCalendarLayout(contentView: contentView)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        
        refreshCalendarDesign()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        
        refreshCalendarDesign()
    }
    
    private func refreshCalendarDesign() {
        contentLayout!.designCalendarView()
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([
            contentLayout!.btnAdd,
            contentLayout!.btnToday], animated: true)
        showLogoOnLeft()
    }
    
    //MARK: call manager
    private func setMode(mode: String) {
        self.mode = mode
        refreshContentWithMode()
    }
    
    private func refreshContentWithMode() {
        switch mode {
        case CalendarVc.modeEvent:
            trainingDataHelper?.show(isShow: false)
            eventDataHelper?.show(isShow: true)
        case CalendarVc.modeTraining:
            eventDataHelper?.show(isShow: false)
            trainingDataHelper?.show(isShow: true)
        default:
            break
        }
    }
    
    //MARK: callbacks
    private func trainingClick(data: [SumTrainingNew]?, position: Int) {
        startTrainingDetailsPagerVc(navController: self.navigationController!, sumTrainings: data, position: position)
    }
    
    private func eventClick(data: [PlanEvent]?, position: Int) {
        let planEvent = data![position]
        startEventDetailsViewController(viewController: self, planEvent: planEvent)
    }
    
    func initError(error: Responses?) {
        self.error = error
        
        errorHandling()
    }
    
    //MARK: error
    private func errorHandling() {
        if let globalError = self.error {
            errorHandlingWithToast(viewController: self, error: globalError)
        }
    }
    
    //MARK: buttons listeners
    @objc private func btnTodayClick() {
        contentLayout!.calendarView.setToday()
    }
    
    @objc private func addClick() {
        startPlanTypeVc(viewController: self)
    }
    
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 0:
            setMode(mode: CalendarVc.modeEvent)
        default:
            setMode(mode: CalendarVc.modeTraining)
        }
    }
}
