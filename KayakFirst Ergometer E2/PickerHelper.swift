//
//  PickerHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 22..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PickerHelper: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: properties
    private let pickerView: UIPickerView
    let textField: UITextField

    //MARK: init
    init(pickerView: UIPickerView, textField: UITextField) {
        self.pickerView = pickerView
        self.textField = textField
        
        super.init()
        
        self.textField.inputView = pickerView
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    //MARK: abstract functions
    func getOptions() -> [String] {
        fatalError("must be implemented")
    }
    
    func getTitle(value: String) -> String {
        fatalError("must be implemented")
    }
    
    func getValue() -> String? {
        fatalError("must be implemented")
    }
    
    //MARK: delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getOptions().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getOptions()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fatalError("must be implemented")
    }
}
