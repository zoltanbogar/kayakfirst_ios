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
    case token_refresh = 2
    case login_normal = 3
    case login_facebook = 4
    case login_google = 5
    case register = 6
    case logout = 7
    case update_user = 8
    case update_pw = 9
    case reset_pw = 10
    
    func isProgressShown() -> Bool {
        return self.rawValue > UserManagerType.token_refresh.rawValue
    }
}
