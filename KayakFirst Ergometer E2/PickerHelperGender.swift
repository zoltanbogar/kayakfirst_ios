//
//  PickerHelperGender.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 22..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PickerHelperGender: PickerHelper {
    
    //MARK: constants
    static let genderOptions = [getString("user_gender_female"), getString("user_gender_male")]
    static let genderFemale = "female"
    static let genderMale = "male"
    
    //MARK: functions
    override func getOptions() -> [String] {
        return PickerHelperGender.genderOptions
    }
    
    override func getTitle(value: String) -> String {
        if value == PickerHelperGender.genderFemale {
            return getString("user_gender_female")
        } else {
            return getString("user_gender_male")
        }
    }
    
    override func getValue() -> String? {
        let genderFemaleLocalized = getString("user_gender_female")
        let genderMaleLocalized = getString("user_gender_male")
        if textField.text == genderFemaleLocalized {
            return PickerHelperGender.genderFemale
        } else if textField.text == genderMaleLocalized {
            return PickerHelperGender.genderMale
        }
        return nil
    }
}
