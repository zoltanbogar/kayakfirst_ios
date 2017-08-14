//
//  PickerHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 22..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PickerHelper: NSObject, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //MARK: properties
    let pickerView: UIPickerView
    let textField: UITextField
    var pickerChangedListener: (() -> ())?

    //MARK: init
    init(pickerView: UIPickerView, textField: UITextField) {
        self.pickerView = pickerView
        self.textField = textField
        
        super.init()
        
        self.textField.inputView = pickerView
        self.textField.delegate = self
        
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.inputView == pickerView {
            if textField.text == nil || textField.text == "" {
                pickerView(pickerView, didSelectRow: 0, inComponent: 0)
            }
        }
    }
    
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
        let selectedOption = getOptions()[row]
        
        textField.text = selectedOption
        
        if let listener = pickerChangedListener {
            listener()
        }
    }
}
