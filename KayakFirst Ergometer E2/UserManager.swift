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
        super.init()
        //private constructor
    }
    
    //MARK: properties
    var token: String? {
        get {
            return UserDb.token
        }
    }
    var refreshToken: String? {
        get {
            return UserDb.refreshToken
        }
    }
    
    var isQuickStart = false
    
    var socialUser: SocialUser?
    
    private let facebookLoginHelper = FacebookLoginHelper.sharedInstance
    private let googleLoginHelper = GoogleLoginHelper.sharedInstance
    
    //MARK: callbacks
    var loginCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var registerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var logoutCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var resetPwCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var updateUserCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var updatePwCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var messageCallback: ((_ data: String?, _ error: Responses?) -> ())?
    var versionCallback: ((_ data: Int?, _ error: Responses?) -> ())?
    
    //MARK: server endpoints
    func register(userDto: UserDto) -> BaseManagerType {
        let userRegister = UserRegister(userDto: userDto)
        
        runUser(serverService: userRegister, managerCallBack: registerCallback)
        
        return UserManagerType.register
    }
    
    func login(userName: String, userPassword: String) -> BaseManagerType {
        let userLogin = UserLogin(userName: userName, userPassword: userPassword)
        
        runUser(serverService: userLogin, managerCallBack: loginCallback)
        
        return UserManagerType.login_normal
    }
    
    func loginFacebook(viewController: UIViewController) -> BaseManagerType {
        facebookLoginHelper.login(viewController: viewController, managerCallBack: { (socialUser, error) in
            if let data = socialUser {
                self.socialUser = data
                
                let userLoginFacebook = UserLoginFacebook(facebookToken: data.facebookToken!)
                self.runUser(serverService: userLoginFacebook, managerCallBack: self.loginCallback)
            } else {
                self.loginCallback?(false, error)
            }
        })
        
        return UserManagerType.login_facebook
    }
    
    func loginGoogle(viewController: UIViewController) -> BaseManagerType {
        googleLoginHelper.login(viewController: viewController, managerCallBack: { (socialUser, error) in
            if let data = socialUser {
                self.socialUser = data
                
                let userLoginGoogle = UserLoginGoogle(email: data.socialEmail, googleId: data.googleId!)
                self.runUser(serverService: userLoginGoogle, managerCallBack: self.loginCallback)
            } else {
                self.loginCallback?(false, error)
            }
        })
        
        return UserManagerType.login_google
    }
    
    func logout() -> BaseManagerType {
        let userLogout = UserLogout()
        runUser(serverService: userLogout, managerCallBack: { (success, error) in
            if error != nil {
                self.addLoginDto(loginDto: nil)
            }
            
            self.socialLogout()
            
            UploadTimer.stopTimer()
            
            self.logoutCallback?(success, error)
        })
        
        return UserManagerType.logout
    }
    
    func socialLogout() {
        facebookLoginHelper.logout()
        googleLoginHelper.logout()
    }
    
    func resetPassword(email: String) -> BaseManagerType {
        let resetPassword = UserResetPassword(email: email)
        
        runUser(serverService: resetPassword, managerCallBack: resetPwCallback)
        
        return UserManagerType.reset_pw
    }
    
    func update(userDto: UserDto) -> BaseManagerType {
        let userUpdate = UserUpdate(userDto: userDto)
        
        runUser(serverService: userUpdate, managerCallBack: updateUserCallback)
        
        return UserManagerType.update_user
    }
    
    func updatePassword(currentPassword: String, newPassword: String) -> BaseManagerType {
        let updatePassword = UpdatePassword(currentPassword: currentPassword, newPassword: newPassword)
        
        runUser(serverService: updatePassword, managerCallBack: updatePwCallback)
        
        return UserManagerType.update_pw
    }
    
    func uploadPushId(pushId: String) -> Bool {
        return ManagerUpload.addToStack(uploadType: UploadType.pushIdUpload, pointer: pushId)
    }
    
    func getMessage() {
        let downloadMessage = DownloadMessage()
        runUser(serverService: downloadMessage, managerCallBack: { (data, error) in
            if let callback = self.messageCallback {
                callback(data, error)
            }
            
            self.getActualVersionCode()
        })
    }
    
    func getActualVersionCode() {
        let downloadVersionCode = DownloadVersionCode()
        runUser(serverService: downloadVersionCode, managerCallBack: versionCallback)
    }
    
    //TODO: change it to the real implementation
    func sendFeedback(managerCallback: @escaping (_ data: Bool?, _ error: Responses?) -> ()) -> BaseManagerType {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            managerCallback(true, nil)
            
            let systemInfo = AppLog.getSystemInfo()
            
            log("SYSTEM_TEST", "systemInfo: \(systemInfo)")
        })
        return UserManagerType.send_feedback
    }
    
    func addUser(user: User?) {
        UserDb.addUser(user: user)
    }
    
    func addLoginDto(loginDto: LoginDto?) {
        UserDb.addLoginDto(loginDto: loginDto)
        
        checkSystemInfo()
    }
    
    func getTrainingType() -> TrainingType {
        return TrainingType.kayak
    }
    
    func getUser() -> User? {
        return UserDb.getUser()
    }
    
    func setTokens(token: String?, refreshToken: String?) {
        UserDb.setTokens(token: token, refreshToken: refreshToken)
    }
}
