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
    case token_refresh = 1
    case login_normal = 2
    case login_facebook = 3
    case login_google = 4
    case register = 5
    case logout = 6
    case update_user = 7
    case update_pw = 8
    case reset_pw = 9
    
    func isProgressShown() -> Bool {
        return self.rawValue > UserManagerType.token_refresh.rawValue
    }
}
