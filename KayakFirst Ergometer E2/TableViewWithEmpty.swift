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
    var _dataList: [E]?
    var dataList: [E]? {
        get {
            return _dataList
        }
        set {
            _dataList = newValue
            reloadData()
        }
    }
    
    //MARK: init
    init(view: UIView, frame: CGRect) {
        super.init(frame: frame, style: .plain)
        
        view.addSubview(getEmptyView())
        getEmptyView().snp.makeConstraints { make in
            make.center.equalTo(view)
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
        
        if _dataList != nil && _dataList!.count > 0 {
            itemCount = _dataList!.count
        }
        
        getEmptyView().isHidden = itemCount > 0
        
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AppUITableViewCell<E>
        
        cell.data = dataList?[indexPath.row]
        
        return cell
    }
    
    //MARK: abstract functions
    func getEmptyView() -> UIView {
        fatalError("Must be implemented")
    }
    
    func getCellClass() -> AnyClass {
        fatalError("Must be implemented")
    }
    
}
