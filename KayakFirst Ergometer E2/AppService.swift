//
//  AppService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 31..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AppService {
    
    internal init() {
        //private empty constructor
    }
    
    //MARK: system
    internal let preferences = UserDefaults.standard
    
    //MARK: properties
    var token: String? {
        get {
            if preferences.object(forKey: User.keyUserToken) == nil {
                return nil
            } else {
                return preferences.string(forKey: User.keyUserToken)
            }
        }
    }
    private var refreshToken: String? {
        get {
            if preferences.object(forKey: User.keyRefreshToken) == nil {
                return nil
            } else {
                return preferences.string(forKey: User.keyRefreshToken)
            }
        }
    }
    
    internal func runWithTokenCheck(serverService: ServerService<AnyObject>) -> Any? {
        //TODO
        return serverService.run()
    }
    
    private func refreshUserToken() {
        //TODO
    }
    
    internal func setTokens(token: String?, refreshToken: String?) {
        preferences.set(token, forKey: User.keyUserToken)
        preferences.set(refreshToken, forKey: User.keyRefreshToken)
        preferences.synchronize()
    }
}
