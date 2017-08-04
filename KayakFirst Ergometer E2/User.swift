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
    static let keyUserClub = "user_club"
    static let keyUserBodyWeight = "user_body_weight"
    static let keyUserCountry = "user_country"
    static let keyUserGender = "user_gender"
    static let keyUserArtOfPaddling = "user_art_of_paddling"
    static let keyUserName = "user_name"
    static let keyUnitWeight = "unit_weight"
    static let keyUnitDistance = "unit_distance"
    static let keyUnitPace = "unit_pace"
    
    //MARK: constants
    static let unitMetric = "metric"
    static let unitImperial = "imperial"
    
    let id: Int64
    let userName: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let birthDate: TimeInterval?
    let club: String?
    let bodyWeight: Double?
    let country: String?
    let gender: String?
    let artOfPaddling: String?
    let unitWeight: String?
    let unitDistance: String?
    let unitPace: String?
    
    init(id: Int64,
         userName: String?,
         email: String?,
         firstName: String?,
         lastName: String?,
         birthDate: TimeInterval?,
         club: String?,
         bodyWeight: Double?,
         country: String?,
         gender: String?,
         artOfPaddling: String?,
         unitWeight: String?,
         unitDistance: String?,
         unitPace: String?
        ) {
        self.id = id
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.club = club
        self.bodyWeight = bodyWeight
        self.country = country
        self.gender = gender
        self.artOfPaddling = artOfPaddling
        self.unitWeight = unitWeight
        self.unitDistance = unitDistance
        self.unitPace = unitPace
    }
    
    init(json: JSON) {
        self.id = json["id"].int64Value
        self.userName = json["username"].stringValue
        self.email = json["email"].stringValue
        self.firstName = json["firstName"].stringValue
        self.lastName = json["lastName"].stringValue
        self.birthDate = json["birthDate"].doubleValue
        self.club = json["club"].stringValue
        self.bodyWeight = json["bodyWeight"].doubleValue
        self.country = json["country"].stringValue
        self.gender = json["gender"].stringValue
        self.artOfPaddling = json["artOfPaddling"].stringValue
        self.unitWeight = json["unitWeight"].stringValue
        self.unitDistance = json["unitDistance"].stringValue
        self.unitPace = json["unitPace"].stringValue
    }
}
