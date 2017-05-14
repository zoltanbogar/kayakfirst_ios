//
//  PlanElementTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanElementTableView: TableViewWithEmpty<PlanElement> {
    
    //MARK: constants
    private let cellNormal = "cell_normal"
    private let cellAdd = "cell_add"
    private let cellSpace = "cell_space"
    
    //MARK: properties
    private let emptyView = UIView()
    
    var type: PlanType?
    var planId: String?
    
    var positionToAdd = -1
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorTransparent
        
        register(PECellNormal.self, forCellReuseIdentifier: cellNormal)
        register(PECellAdd.self, forCellReuseIdentifier: cellAdd)
        register(PECellSpace.self, forCellReuseIdentifier: cellSpace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: functions
    func addPlanElementsAll(planElements: [PlanElement]?) {
        dataList = planElements
        positionToAdd = getPlanElementCount()
    }
    
    func addPlanElement(planElement: PlanElement) {
        dataList?.remove(at: positionToAdd)
        dataList?.insert(planElement, at: positionToAdd)
        
        reloadData()
    }
    
    func deletePlanElement(position: Int) {
        let deletePosition = position / 2
        
        dataList?.remove(at: deletePosition)
        reloadData()
    }
    
    override func getEmptyView() -> UIView {
        return emptyView
    }
    
    override func getCellClass() -> AnyClass {
        return PECellNormal.self
    }
    
    //MARK: tableView source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemCount()
    }
    
    private func getItemCount() -> Int {
        let planElementCount = getPlanElementCount()
        
        return planElementCount + planElementCount + 1
    }
    
    private func addNewPlanElement() {
        if dataList == nil {
            dataList = [PlanElement]()
        }
        let planElement = PlanElement(planId: planId!, type: type!)
        dataList?.insert(planElement, at: positionToAdd)
        
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        
        var cell: AppUITableViewCell<PlanElement>? = nil
        
        switch getViewType(indexPath: indexPath) {
        case cellSpace:
            cell = tableView.dequeueReusableCell(withIdentifier: cellSpace, for: indexPath) as! PECellSpace
        case cellAdd:
            cell = tableView.dequeueReusableCell(withIdentifier: cellAdd, for: indexPath) as! PECellAdd
        case cellNormal:
            let cellNormal = tableView.dequeueReusableCell(withIdentifier: self.cellNormal, for: indexPath) as! PECellNormal
            
            cellNormal.data = dataList?[position / 2]
            
            cell = cellNormal
        default:
            fatalError("no other types")
        }
        
        rowHeight = cell!.getRowHeight()
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch getViewType(indexPath: indexPath) {
        case cellSpace:
            positionToAdd = ((indexPath.row + 1) / 2)
            addNewPlanElement()
            break
        case cellAdd:
            positionToAdd = getPlanElementCount()
            addNewPlanElement()
            break
        case cellNormal:
            //TODO
            break
        default:
            fatalError("no other types")
        }
    }
    
    private func getPlanElementCount() -> Int {
        return dataList != nil ? dataList!.count : 0
    }
    
    private func getViewType(indexPath: IndexPath) -> String {
        let position = indexPath.row
        
        if getPlanElementCount() > 0 {
            if position % 2 == 1 && position != 0 {
                return cellSpace
            } else if position == (getItemCount() - 1) {
                return cellAdd
            } else {
                return cellNormal
            }
        } else {
            return cellAdd
        }
    }
}
