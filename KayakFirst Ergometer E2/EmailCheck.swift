//
//  EmailCheck.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func isValidEmail(email: String?) -> Bool {
    if let emailText = email {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailText)
    } else {
        return false
    }
    
}
