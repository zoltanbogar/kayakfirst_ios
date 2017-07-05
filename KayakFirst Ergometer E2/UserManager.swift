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
    
    var isQuickStart = false
    
    //MARK: callbacks
    var loginCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var registerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var logoutCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var resetPwCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var updateUserCallback: ((_ data: User?, _ error: Responses?) -> ())?
    var updatePwCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
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
    
    func loginFacebook(facebookToken: String) -> BaseManagerType {
        let userLoginFacebook = UserLoginFacebook(facebookToken: facebookToken)
        
        runUser(serverService: userLoginFacebook, managerCallBack: loginCallback)
        
        return UserManagerType.login_facebook
    }
    
    func loginGoogle(email: String, googleId: String) -> BaseManagerType {
        let userLoginGoogle = UserLoginGoogle(email: email, googleId: googleId)
        
        runUser(serverService: userLoginGoogle, managerCallBack: loginCallback)
        
        return UserManagerType.login_google
    }
    
    func logout() -> BaseManagerType {
        let userLogout = UserLogout()
       
        runUser(serverService: userLogout, managerCallBack: logoutCallback)
        
        return UserManagerType.logout
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
    
    func addUser(user: User?) {
        var userId: Int64 = 0
        var userName: String? = nil
        var userEmail: String? = nil
        var firstName: String? = nil
        var lastName: String? = nil
        var birthDate: TimeInterval? = 0
        var club: String? = nil
        var bodyWeight: Double? = 0
        var country: String? = nil
        var gender: String? = nil
        var artOfPaddling: String? = nil
        var unitWeight: String? = nil
        var unitDistance: String? = nil
        var unitPace: String? = nil
        
        if let newUser = user {
            userId = newUser.id
            userName = newUser.userName
            userEmail = newUser.email
            firstName = newUser.firstName
            lastName = newUser.lastName
            birthDate = newUser.birthDate
            club = newUser.club
            bodyWeight = newUser.bodyWeight
            country = newUser.country
            gender = newUser.gender
            artOfPaddling = newUser.artOfPaddling
            unitWeight = newUser.unitWeight
            unitDistance = newUser.unitDistance
            unitPace = newUser.unitPace
        }
        
        preferences.set(userId, forKey: User.keyUserId)
        preferences.set(userName, forKey: User.keyUserName)
        preferences.set(userEmail, forKey: User.keyUserEmail)
        preferences.set(firstName, forKey: User.keyUserFirstName)
        preferences.set(lastName, forKey: User.keyUserLastName)
        preferences.set(birthDate, forKey: User.keyUserBirthDate)
        preferences.set(club, forKey: User.keyUserClub)
        preferences.set(bodyWeight, forKey: User.keyUserBodyWeight)
        preferences.set(country, forKey: User.keyUserCountry)
        preferences.set(gender, forKey: User.keyUserGender)
        preferences.set(artOfPaddling, forKey: User.keyUserArtOfPaddling)
        preferences.set(unitWeight, forKey: User.keyUnitWeight)
        preferences.set(unitDistance, forKey: User.keyUnitDistance)
        preferences.set(unitPace, forKey: User.keyUnitPace)
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
    
    func getTrainingType() -> TrainingType {
        return TrainingType.kayak
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
                club: preferences.string(forKey: User.keyUserClub),
                bodyWeight: preferences.double(forKey: User.keyUserBodyWeight),
                country: preferences.string(forKey: User.keyUserCountry),
                gender: preferences.string(forKey: User.keyUserGender),
                artOfPaddling: preferences.string(forKey: User.keyUserArtOfPaddling),
                unitWeight: preferences.string(forKey: User.keyUnitWeight),
                unitDistance: preferences.string(forKey: User.keyUnitDistance),
                unitPace: preferences.string(forKey: User.keyUnitPace))
        }
        return nil
    }
    
    func setTokens(token: String?, refreshToken: String?) {
        preferences.set(token, forKey: User.keyUserToken)
        preferences.set(refreshToken, forKey: User.keyRefreshToken)
        preferences.synchronize()
    }
}
