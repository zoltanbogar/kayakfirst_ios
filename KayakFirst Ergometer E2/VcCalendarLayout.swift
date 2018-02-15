//
//  VcCalendarLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcCalendarLayout: BaseLayout {
    
    private let segmentItems = [getString("plan_plan"), getString("training_log").capitalized]
    
    private var stackView: UIStackView?
    let viewTableView = UIView()
    let viewCalendar = UIView()
    
    override func setView() {
        stackView = UIStackView()
        stackView?.spacing = margin
        
        viewCalendar.addSubview(calendarView)
        viewCalendar.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(viewCalendar).offset(-2 * margin2)
            make.centerX.equalTo(viewCalendar)
            make.top.equalTo(viewCalendar).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
            make.height.equalTo(25)
        }
        
        stackView?.addArrangedSubview(viewCalendar)
        stackView?.addArrangedSubview(viewTableView)
        
        calendarView.snp.makeConstraints { (make) in
            make.edges.equalTo(viewCalendar)
        }
        
        contentView.addSubview(stackView!)
        stackView?.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    override func handlePortraitLayout(size: CGSize) {
        stackView?.axis = .vertical
        
        calendarView.handlePortraitLayout(size: size)
        
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
        
        calendarView.handleLandscapeLayout(size: size)
        
        viewTableView.snp.removeConstraints()
        viewTableView.snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
    }
    
    func designCalendarView() {
        calendarView.designCalendarView()
    }
    
    lazy var calendarView: CalendarView! = {
        let calendarView = CalendarView()
        
        return calendarView
    }()
    
    lazy var trainingListView: TrainingCalendarListView! = {
        let view = TrainingCalendarListView()
        
        return view
    }()
    
    lazy var eventListView: EventCalendarListView! = {
        let view = EventCalendarListView()
        
        return view
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
