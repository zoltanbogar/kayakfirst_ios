//
//  PasswordCheck.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//TODO: delete this class
class PasswordCheck {
    
    private static let minCharacterPassword = 4
    
    class func isPasswordValid(password: String?) -> Bool {
        if let passwordText = password {
            return passwordText.characters.count >= minCharacterPassword
        }
        return false
    }
    
}

