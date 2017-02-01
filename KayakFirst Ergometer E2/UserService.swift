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
    
    func login(userDataCallBack: UserDataCallBack, userName: String?, userPassword: String?) {
        if userName != nil && userPassword != nil {
            let userLogin: ServerService = UserLogin(userName: userName!, userPassword: userPassword!)
            LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: userLogin).execute(param: nil)
        }
    }
    
    //MARK: AsyncTask
    private class LoadUserData: AsyncTask<Any, Any, Any> {
        
        private var userService: UserService
        private var userDataCallback: UserDataCallBack?
        private var serverService: ServerService<AnyObject>
        
        init(userService: UserService, userDataCallback: UserDataCallBack?, serverService: ServerService<AnyObject>) {
            self.userService = userService
            self.userDataCallback = userDataCallback
            self.serverService = serverService
        }
        
        internal override func doInBackground(param: Any?) -> Any? {
            return userService.runWithTokenCheck(serverService: serverService)
        }
        
        internal override func onPostExecute(result: Any?) {
            if let callback = userDataCallback {
                if result != nil {
                    callback.onUserDataAvailable(data: result)
                } else {
                    callback.onError(error: serverService.error!)
                }
            }
        }
    }
}

//MARK: Protocols
protocol UserDataCallBack {
    func onUserDataAvailable(data: Any?)
    func onError(error: Responses)
}
