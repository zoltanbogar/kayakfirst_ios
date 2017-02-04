//
//  UserService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 01..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class UserService: AppService {
    
    //MARK: init
    static let sharedInstance: UserService = UserService()
    private override init() {
        //private constructor
    }
    
    //MARK: server endpoints
    func login(userDataCallBack: @escaping (_ error: Responses?, _ userData: LoginDto?) -> (), userName: String, userPassword: String) {
        let userLogin = UserLogin(userName: userName, userPassword: userPassword)
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: userLogin).execute()
    }
    
    func resetPassword(userDataCallBack: @escaping (_ error: Responses?, _ userData: User?) -> (), currentPassword: String, newPassword: String) {
        let updatePassword = UpdatePassword(currentPassword: currentPassword, newPassword: newPassword)
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: updatePassword).execute()
    }
    
    //MARK: tokens
    internal let preferences = UserDefaults.standard
    
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
    
    internal func setTokens(token: String?, refreshToken: String?) {
        preferences.set(token, forKey: User.keyUserToken)
        preferences.set(refreshToken, forKey: User.keyRefreshToken)
        preferences.synchronize()
    }
}

//MARK: AsyncTask
private class LoadUserData<UserData>: AsyncTask<Any, Any, UserData> {
    
    private var userService: UserService
    private var userDataCallback: (_ error: Responses?, _ userData: UserData?) -> ()
    private var serverService: ServerService<UserData>
    
    init(userService: UserService, userDataCallback: @escaping (_ error: Responses?, _ userData: UserData?) -> (), serverService: ServerService<UserData>) {
        self.userService = userService
        self.userDataCallback = userDataCallback
        self.serverService = serverService
    }
    
    internal override func doInBackground(param: Any?) -> UserData? {
        return userService.runWithTokenCheck(serverService: serverService)
    }
    
    internal override func onPostExecute(result: UserData?) {
        userDataCallback(serverService.error, result)
    }
}
