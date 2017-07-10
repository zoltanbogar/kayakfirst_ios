//
//  PlanDetailsTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 15..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanDetailsTableView: TableViewWithEmpty<Plan> {
    
    //MARK: constants
    private let cellBase = "cell_base"
    private let cellEdit = "cell_edit"
    private let cellPlanElement = "cell_plan_element"
    
    //MARK: properties
    private let emptyView = UIView()
    private var _plan: Plan?
    var plan: Plan? {
        get {
            if let cell = planDetailsCell {
                _plan?.name = cell.etName.text
                _plan?.notes = cell.etNotes.text
            }
            return _plan
        }
        set {
            _plan = newValue
            reloadData()
        }
    }
    private var isEdit = false
    private var editShouldFinish = false
    var isNameValid: Bool {
        get {
            if let cell = planDetailsCell {
                return Validate.isValidPlanName(etName: cell.etName)
            } else {
                return false
            }
        }
    }
    private var planDetailsCell: PlanDetailsCell?
    
    //MARK: functions
    func setEdit(edit: Bool, editShouldFinish: Bool) {
        self.isEdit = edit
        self.editShouldFinish = editShouldFinish
        
        reloadData()
    }
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorTransparent
        
        register(PlanDetailsCell.self, forCellReuseIdentifier: cellBase)
        register(PlanEditIntervallsCell.self, forCellReuseIdentifier: cellEdit)
        register(PlanElementDetailsCell.self, forCellReuseIdentifier: cellPlanElement)
        
        self.setDefaultRowHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func getEmptyView() -> UIView {
        return emptyView
    }
    
    override func getCellClass() -> AnyClass {
        return PlanDetailsCell.self
    }
    
    //MARK: tableView source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemCount()
    }
    
    private func getItemCount() -> Int {
        var baseCount = 1
        
        if let planValue = _plan {
            if let planEValue = planValue.planElements {
                baseCount += planEValue.count
            }
        }
        
        if isEdit {
            baseCount += 1
        }
        
        return baseCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        
        var cell: UITableViewCell? = nil
        
        switch getViewType(indexPath: indexPath) {
        case cellBase:
            let cellDetails = tableView.dequeueReusableCell(withIdentifier: cellBase, for: indexPath) as! PlanDetailsCell
            
            (cellDetails as! PlanDetailsCell).isEdit = isEdit
            
            cellDetails.data = _plan

            cell = cellDetails
            
            (cellDetails as! PlanDetailsCell).textHeightChangeListener = {
                UIView.setAnimationsEnabled(false)
                self.beginUpdates()
                self.endUpdates()
                UIView.setAnimationsEnabled(true)
            }
            
            self.planDetailsCell = (cellDetails as! PlanDetailsCell)
        case cellEdit:
            cell = tableView.dequeueReusableCell(withIdentifier: cellEdit, for: indexPath) as! PlanEditIntervallsCell
            
        case cellPlanElement:
            let cellNormal = tableView.dequeueReusableCell(withIdentifier: self.cellPlanElement, for: indexPath) as! PlanElementDetailsCell
            
            (cellNormal as! PlanElementDetailsCell).isEdit = isEdit
            
            let dataPosition = isEdit ? (position - 2) : (position - 1)
            
            cellNormal.data = _plan?.planElements?[dataPosition]
            
            cell = cellNormal
        default:
            fatalError("no other types")
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if getViewType(indexPath: indexPath) == cellEdit {
            if editShouldFinish {
                let name = planDetailsCell?.etName.text
                let notes = planDetailsCell?.etNotes.text
                
                CreatePlanViewController.staticName = name
                CreatePlanViewController.staticNotes = notes
                
                viewController()!.dismiss(animated: true, completion: nil)
            } else {
                startCreatePlanViewController(viewController: viewController()!, plan: _plan!)
            }
        }
    }
    
    private func getPlanElementCount() -> Int {
        return dataList != nil ? dataList!.count : 0
    }
    
    private func getViewType(indexPath: IndexPath) -> String {
        let position = indexPath.row
        
        switch position {
        case 0:
            return cellBase
        case 1:
            if isEdit {
                return cellEdit
            } else {
                return cellPlanElement
            }
        default:
            return cellPlanElement
        }
    }
    
    private func setDefaultRowHeight() {
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 50
    }
}
