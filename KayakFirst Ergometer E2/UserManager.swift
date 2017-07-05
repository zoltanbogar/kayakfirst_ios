//
//  UserManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 23..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class UserManager: BaseManager {
    
    //MARK: init
    static let sharedInstance = UserManager()
    private override init() {
        //private constructor
    }
    
    //TODO: implement the correct method
    func getUser() -> User? {
        return UserService.sharedInstance.getUser()
    }
    
    func setTokens(token: String, refreshToken: String) {
        //TODO: implement the correct method
    }
    
    var refreshToken: String? {
        //TODO: implement the correct method
        /*get {
            if preferences.object(forKey: User.keyRefreshToken) == nil {
                return nil
            } else {
                return preferences.string(forKey: User.keyRefreshToken)
            }
        }*/
        return nil
    }
}
