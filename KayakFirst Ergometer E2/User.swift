//
//  User.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 31..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import SwiftyJSON

struct User {
    
    //MARK: preferences
    static let keyUserId = "user_id"
    static let keyUserEmail = "user_email"
    static let keyUserToken = "user_token"
    static let keyRefreshToken = "refresh_token"
    static let keyUserFirstName = "user_first_name"
    static let keyUserLastName = "user_last_name"
    static let keyUserBirthDate = "user_birth_date"
    static let keyUserBodyWeight = "user_body_weight"
    static let keyUserCountry = "user_country"
    static let keyUserGender = "user_gender"
    static let keyUserName = "user_name"
    
    //MARK: constants
    static let genderOptions = [getString("user_gender_female"), getString("user_gender_male")]
    static let genderFemale = "female"
    static let genderMale = "male"
    static let minCharacterUserName = 2
    static let minCharacterPassword = 4
    static let minBodyWeight = 30
    
    let id: Int64
    let userName: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let birthDate: TimeInterval?
    let bodyWeight: Double?
    let country: String?
    let gender: String?
    
    init(id: Int64,
         userName: String?,
         email: String?,
         firstName: String?,
         lastName: String?,
         birthDate: TimeInterval?,
         bodyWeight: Double?,
         country: String?,
         gender: String?
        ) {
        self.id = id
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.bodyWeight = bodyWeight
        self.country = country
        self.gender = gender
    }
    
    init(json: JSON) {
        self.id = json["id"].int64Value
        self.userName = json["username"].stringValue
        self.email = json["email"].stringValue
        self.firstName = json["firstName"].stringValue
        self.lastName = json["lastName"].stringValue
        self.birthDate = json["birthDate"].doubleValue
        self.bodyWeight = json["bodyWeight"].doubleValue
        self.country = json["country"].stringValue
        self.gender = json["gender"].stringValue
    }
}
