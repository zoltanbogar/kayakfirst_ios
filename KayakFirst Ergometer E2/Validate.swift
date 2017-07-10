//
//  Validate.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 23..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class Validate {
    
    //MARK
    private static let minCharacterPassword = 4
    private static let minCharacterUserName = 2
    private static let minBodyWeight = 30
    
    class func isValidEmail(email: String?) -> Bool {
        if let emailText = email {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: emailText)
        } else {
            return false
        }
    }
    
    class func isUserNameValid(tfUserName: DialogElementTextField) -> Bool {
        var isValid = true
        let userNameCharacters = tfUserName.text == nil ? 0 : tfUserName.text!.characters.count
        if userNameCharacters < Validate.minCharacterUserName {
            tfUserName.error = getString("error_user_name")
            isValid = false
        }
        return isValid
    }
    
    class func isPasswordValid(tfPassword: DialogElementTextField) -> Bool {
        var isValid = true
        let passwordCharacters = tfPassword.text == nil ? 0 : tfPassword.text!.characters.count
        if passwordCharacters < Validate.minCharacterPassword {
            tfPassword.error = getString("error_password")
            isValid = false
        }
        return isValid
    }
    
    class func isValidBodyWeight(tfWeight: DialogElementTextField, isMetric: Bool) -> Bool {
        var isValid = true
        tfWeight.error = nil
        
        let bodyWeight: Double = tfWeight.text == nil || tfWeight.text == "" ? 0 :
            UnitHelper.getMetricWeightValue(value: Double(tfWeight.text!)!, isMetric: isMetric)
        if bodyWeight < Double(Validate.minBodyWeight) {
            let originalErrorText = getString("error_weight")
            
            let minWeight = UnitHelper.getWeightValue(value: Double(Validate.minBodyWeight), isMetric: isMetric)
            
            let minWeightFormatted: Int = (minWeight - Double(Int(minWeight))) > 0 ? (Int(minWeight) + 1) : Int(minWeight)
            
            let weightFormatted = " \(minWeightFormatted) \(UnitHelper.getWeightUnit(isMetric: isMetric))"
            
            let errorText = originalErrorText + weightFormatted + "!"
            
            tfWeight.error = errorText
            isValid = false
        }
        return isValid
    }
    
    class func isValidPicker(tfPicker: DialogElementTextField) -> Bool {
        var isValid = true
        tfPicker.error = nil
        
        if tfPicker.text! == "" {
            isValid = false
            tfPicker.error = getString("user_spinner_choose")
        }
        return isValid
    }
    
    class func isValidPlanName(etName: ProfileElement) -> Bool {
        let isValid = etName.text != nil && etName.text != ""
        if !isValid {
            etName.error = getString("error_plan_name")
        }
        return isValid
    }
    
    class func isEventTimestampValid(viewController: UIViewController, timestamp: Double) -> Bool {
        let isValid = timestamp > currentTimeMillis()
        
        if !isValid {
            ErrorDialog(errorString: getString("error_event_timestamp_past")).show(viewController: viewController)
        }
        return isValid
    }
    
    class func isValidPlan(viewController: UIViewController, plan: Plan?) -> Bool {
        let isValid = plan != nil && plan!.planElements != nil && plan!.planElements!.count > 0
        
        if !isValid {
            PlanNoElementsDialog().show(viewController: viewController)
        }
        return isValid
    }
}
