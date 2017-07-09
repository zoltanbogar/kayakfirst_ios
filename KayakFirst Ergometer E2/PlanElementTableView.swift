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
    private let cellBlank = "cell_blank"
    private let cellSpace = "cell_space"
    
    //MARK: properties
    private let emptyView = UIView()
    
    var type: PlanType?
    
    var positionToAdd = 0
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorTransparent
        
        register(PECellNormal.self, forCellReuseIdentifier: cellNormal)
        register(PECellBlank.self, forCellReuseIdentifier: cellBlank)
        register(PECellSpace.self, forCellReuseIdentifier: cellSpace)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: functions
    func addPlanElementsAll(planElements: [PlanElement]?) {
        dataList = planElements
        positionToAdd = getPlanElementCount()
        
        reloadData()
    }
    
    func addPlanElement(planElement: PlanElement) {
        if dataList == nil {
            dataList = [PlanElement]()
        }
        dataList?.insert(planElement, at: positionToAdd)
        positionToAdd = getPlanElementCount()
        
        reloadData()
    }
    
    func deletePlanElement(position: Int) {
        let deletePosition = position / 2
        
        dataList?.remove(at: deletePosition)
        positionToAdd = getPlanElementCount()
        
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
        
        return (planElementCount * 2) + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        
        var cell: AppUITableViewCell<PlanElement>? = nil
        
        switch getViewType(indexPath: indexPath) {
        case cellSpace:
            cell = tableView.dequeueReusableCell(withIdentifier: cellSpace, for: indexPath) as! PECellSpace
        case cellBlank:
            cell = tableView.dequeueReusableCell(withIdentifier: cellBlank, for: indexPath) as! PECellBlank
            
            switch type! {
            case PlanType.distance:
                (cell as! PECellBlank).title = "0"
            default:
                (cell as! PECellBlank).title = "00:00"
            }
            
        case cellNormal:
            let cellNormal = tableView.dequeueReusableCell(withIdentifier: self.cellNormal, for: indexPath) as! PECellNormal
            
            let planPosition = (position / 2 >= positionToAdd) ? ((position / 2) - 1) : (position / 2)
            
            cellNormal.data = dataList?[planPosition]
            
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
            if indexPath.row / 2 != positionToAdd {
                let tempPositionToAdd = ((indexPath.row + 1) / 2)
                
                if indexPath.row > positionToAdd * 2 {
                    positionToAdd = tempPositionToAdd - 1
                } else {
                    positionToAdd = tempPositionToAdd
                }
                reloadData()
            }
            break
        case cellBlank:
            //nothing here
            break
        case cellNormal:
            //nothing here
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
            } else if position == (positionToAdd * 2) {
                return cellBlank
            } else {
                return cellNormal
            }
        } else {
            return cellBlank
        }
    }
}
