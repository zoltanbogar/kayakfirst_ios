//
//  VcCalendarLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CVCalendar

class VcCalendarLayout: BaseLayout {
    
    private let segmentItems = [getString("plan_plan"), getString("training_log").capitalized]
    private let calendarHeight: CGFloat = 190
    
    private var stackView: UIStackView?
    let viewTableView = UIView()
    let viewCalendar = UIView()
    
    override func setView() {
        stackView = UIStackView()
        stackView?.spacing = margin
        
        viewCalendar.addSubview(cvCalendarView)
        viewCalendar.addSubview(labelMonth)
        viewCalendar.addSubview(calendarMenuView)
        viewCalendar.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(viewCalendar).offset(-2 * margin2)
            make.centerX.equalTo(viewCalendar)
            make.top.equalTo(viewCalendar).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
            make.height.equalTo(25)
        }
        labelMonth.snp.makeConstraints { (make) in
            make.width.equalTo(viewCalendar)
            make.top.equalTo(segmentedControl.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        stackView?.addArrangedSubview(viewCalendar)
        stackView?.addArrangedSubview(viewTableView)
        
        contentView.addSubview(stackView!)
        stackView?.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        tableViewTraining.addSubview(progressBarTraining)
        progressBarTraining.snp.makeConstraints { make in
            make.center.equalTo(tableViewTraining)
        }
        tableViewEvent.addSubview(progressBarEvent)
        progressBarEvent.snp.makeConstraints { (make) in
            make.center.equalTo(tableViewEvent)
        }
    }
    
    //TODO: not good portrait
    override func handlePortraitLayout(size: CGSize) {
        stackView?.axis = .vertical
        
        let width: CGFloat = size.width
        let height: CGFloat = calendarHeight
        
        cvCalendarView.frame = CGRect(x: 0, y: 100, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 75, width: width, height: 20)
        
        let screenheight = UIScreen.main.bounds.height
        let tableViewHeight = screenheight >= 600 ? (screenheight / 2.6) : (screenheight / 3.7)
        
        viewTableView.snp.removeConstraints()
        viewTableView.snp.makeConstraints { (make) in
            make.height.equalTo(tableViewHeight)
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        stackView?.axis = .horizontal
        
        let width: CGFloat = size.width / 2
        let height: CGFloat = calendarHeight
        
        cvCalendarView.frame = CGRect(x: 0, y: 90, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 75, width: width, height: 20)
        
        viewTableView.snp.removeConstraints()
        viewTableView.snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
    }
    
    func designCalendarView() {
        cvCalendarView.appearance.dayLabelWeekdayInTextColor = Colors.colorWhite
        cvCalendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = Colors.colorAccent
        cvCalendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = Colors.colorAccent
    }
    
    lazy var tableViewTraining: TrainingTablewView! = {
        let tableViewTraining = TrainingTablewView(view: self.viewTableView)
        
        return tableViewTraining
    }()
    
    lazy var progressBarTraining: AppProgressBar! = {
        let spinner = AppProgressBar()
        
        return spinner
    }()
    
    lazy var tableViewEvent: EventTableView! = {
        let tableViewEvent = EventTableView(view: self.viewTableView)
        
        return tableViewEvent
    }()
    
    lazy var progressBarEvent: AppProgressBar! = {
        let spinner = AppProgressBar()
        
        return spinner
    }()
    
    lazy var labelMonth: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var cvCalendarView: CVCalendarView! = {
        let calendarView = CVCalendarView(frame: CGRect(x: 0, y: 120, width: self.contentView.frame.width, height: 200))
        
        self.labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: currentTimeMillis())
        
        return calendarView
    }()
    
    lazy var calendarMenuView: CVCalendarMenuView! = {
        let calendarMenuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 95, width: self.contentView.frame.width, height: 20))
        calendarMenuView.dayOfWeekTextColor = Colors.colorWhite
        
        return calendarMenuView
    }()
    
    lazy var segmentedControl: UISegmentedControl! = {
        let control = UISegmentedControl(items: self.segmentItems)
        control.tintColor = Colors.colorAccent
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    //MARK: bar buttons
    lazy var btnToday: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_event_white_24dp")
        
        return button
    }()
    
    lazy var btnAdd: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_add_white")
        
        return button
    }()
    
}
