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
    func register(userDataCallBack: @escaping (_ error: Responses?, _ userData: User?) -> (), userDto: UserDto) {
        let userRegister = UserRegister(userDto: userDto)
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: userRegister).execute()
    }
    
    func login(userDataCallBack: @escaping (_ error: Responses?, _ userData: LoginDto?) -> (), userName: String, userPassword: String) {
        let userLogin = UserLogin(userName: userName, userPassword: userPassword)
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: userLogin).execute()
    }
    
    func logout(userDataCallBack: @escaping (_ error: Responses?, _ userData: Bool?) -> ()) {
        let userLogout = UserLogout()
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: userLogout).execute()
    }
    
    func resetPassword(userDataCallBack: @escaping (_ error: Responses?, _ userData: User?) -> (), currentPassword: String, newPassword: String) {
        let updatePassword = UpdatePassword(currentPassword: currentPassword, newPassword: newPassword)
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: updatePassword).execute()
    }
    
    func resetPassword(userDataCallBack: @escaping (_ error: Responses?, _ userData: Bool?) -> (), email: String) {
        let resetPassword = UserResetPassword(email: email)
        LoadUserData(userService: self, userDataCallback: userDataCallBack, serverService: resetPassword).execute()
    }
    
    //MARK: user
    func addUser(user: User?) {
        var userId: Int64 = 0
        var userName: String? = nil
        var userEmail: String? = nil
        var firstName: String? = nil
        var lastName: String? = nil
        var birthDate: TimeInterval? = 0
        var bodyWeight: Double? = 0
        var country: String? = nil
        var gender: String? = nil
        
        if let newUser = user {
            userId = newUser.id
            userName = newUser.userName
            userEmail = newUser.email
            firstName = newUser.firstName
            lastName = newUser.lastName
            birthDate = newUser.birthDate
            bodyWeight = newUser.bodyWeight
            country = newUser.country
            gender = newUser.gender
        }
        
        preferences.set(userId, forKey: User.keyUserId)
        preferences.set(userName, forKey: User.keyUserName)
        preferences.set(userEmail, forKey: User.keyUserEmail)
        preferences.set(firstName, forKey: User.keyUserFirstName)
        preferences.set(lastName, forKey: User.keyUserLastName)
        preferences.set(birthDate, forKey: User.keyUserBirthDate)
        preferences.set(bodyWeight, forKey: User.keyUserBodyWeight)
        preferences.set(country, forKey: User.keyUserCountry)
        preferences.set(gender, forKey: User.keyUserGender)
        preferences.synchronize()
    }
    
    func addLoginDto(loginDto: LoginDto?) {
        var user: User? = nil
        var userToken: String? = nil
        var refreshToken: String? = nil
        
        if let newLoginDto = loginDto {
            user = newLoginDto.user
            userToken = newLoginDto.userToken
            refreshToken = newLoginDto.refreshToken
        }
        
        addUser(user: user)
        
        setTokens(token: userToken, refreshToken: refreshToken)
    }
    
    func getUser() -> User? {
        let userEmail = preferences.string(forKey: User.keyUserEmail)
        
        if userEmail != nil {
            return User(
                id: Int64(preferences.integer(forKey: User.keyUserId)),
                userName: preferences.string(forKey: User.keyUserName),
                email: userEmail,
                firstName: preferences.string(forKey: User.keyUserFirstName),
                lastName: preferences.string(forKey: User.keyUserLastName),
                birthDate: preferences.double(forKey: User.keyUserBirthDate),
                bodyWeight: preferences.double(forKey: User.keyUserBodyWeight),
                country: preferences.string(forKey: User.keyUserCountry),
                gender: preferences.string(forKey: User.keyUserGender))
        }
        return nil
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
    var refreshToken: String? {
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
