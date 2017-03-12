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
    
    //MARK: constants
    static let genderOptions = [getString("user_gender_female"), getString("user_gender_male")]
    static let genderFemale = "female"
    static let genderMale = "male"
    static let artOfPaddlingOptions = [getString("user_art_of_paddling_racing_kayaking"), getString("user_art_of_paddling_racing_canoeing"), getString("user_art_of_paddling_recreational_kayaking"), getString("user_art_of_paddling_recreational_canoeing"), getString("user_art_of_paddling_sup"), getString("user_art_of_paddling_dragon"), getString("user_art_of_paddling_rowing")]
    static let artOfPaddlingRacingKayaking = "racing_kayaking"
    static let artOfPaddlingRacingCanoeing = "racing_canoeing"
    static let artOfPaddlingRecreationalKayaking = "recreational_kayaking"
    static let artOfPaddlingRecreationalCanoeing = "recreational_canoeing"
    static let artOfPaddlingSup = "sup"
    static let artOfPaddlingDragon = "dragon"
    static let artOfPaddlingRowing = "rowing"
    
    static let minCharacterUserName = 2
    static let minCharacterPassword = 4
    static let minBodyWeight = 30
    
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
         artOfPaddling: String?
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
    }
}
