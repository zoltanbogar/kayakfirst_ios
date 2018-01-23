//
//  UserManagerType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum UserManagerType: Int, BaseManagerType {
    
    case uploadPushId = 0
    case downloadMessage = 1
    case downloadVersion = 2
    case token_refresh = 3
    case login_normal = 4
    case login_facebook = 5
    case login_google = 6
    case register = 7
    case logout = 8
    case update_user = 9
    case update_pw = 10
    case reset_pw = 11
    case send_feedback = 12
    
    func isProgressShown() -> Bool {
        return self.rawValue > UserManagerType.token_refresh.rawValue
    }
}
