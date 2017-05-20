//
//  UserManagerType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum UserManagerType: Int, BaseManagerType {
    case token_refresh = 0
    case login_normal = 1
    case login_facebook = 2
    case login_google = 3
    case register = 4
    case logout = 5
    case update_user = 6
    case update_pw = 7
    case reset_pw = 8
    
    func isProgressShown() -> Bool {
        return self.rawValue > UserManagerType.token_refresh.rawValue
    }
}
