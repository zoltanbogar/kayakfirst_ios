//
//  PickerHelperLocale.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 22..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PickerHelperLocale: PickerHelper {
    
    //MARK: properties
    private var value: String?
    
    //MARK: functions
    override func getOptions() -> [String] {
        fatalError()
    }
    
    override func getTitle(value: String) -> String {
        return NSLocale.getCountryNameByCode(countryCode: value)
    }
    
    override func getValue() -> String? {
        return value
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NSLocale.locales().count
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocale.locales()[row].countryName
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        value = NSLocale.locales()[row].countryCode
        
        textField.text = NSLocale.locales()[row].countryName
    }
}
