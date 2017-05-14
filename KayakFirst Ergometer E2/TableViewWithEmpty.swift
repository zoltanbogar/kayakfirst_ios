//
//  TableViewWithEmpty.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TableViewWithEmpty<E>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: constants
    private let cellIdentifier = "cell"
    
    //MARK: data
    var dataList: [E]? {
        didSet {
            reloadData()
        }
    }
    
    //MARK: callback
    var rowClickCallback: ((E, _ position: Int) -> ())?
    
    //MARK: init
    init(view: UIView) {
        super.init(frame: view.frame, style: .plain)
        
        if getHeaderView() != nil {
            sectionHeaderHeight = 40
        }
        
        addSubview(getEmptyView())
        getEmptyView().snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        register(getCellClass(), forCellReuseIdentifier: cellIdentifier)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: tableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var itemCount = 0
        
        if dataList != nil && dataList!.count > 0 {
            itemCount = dataList!.count
        }
        
        getEmptyView().isHidden = itemCount > 0
        getHeaderView()?.isHidden = !getEmptyView().isHidden
        
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AppUITableViewCell<E>
        
        cell.data = dataList?[indexPath.row]
        
        rowHeight = cell.getRowHeight()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let calback = rowClickCallback {
            let position = indexPath.row
            calback(dataList![position], position)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderView()
    }
    
    //MARK: abstract functions
    func getEmptyView() -> UIView {
        fatalError("Must be implemented")
    }
    
    func getCellClass() -> AnyClass {
        fatalError("Must be implemented")
    }
    
    func getHeaderView() -> UIView? {
        //override if needed
        return nil
    }
    
}
