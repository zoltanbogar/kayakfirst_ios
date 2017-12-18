//
//  SocialLoginHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class SocialLoginHelper: NSObject {
    
    var socialFirstName: String?
    var socialLastName: String?
    var socialEmail: String?
    var facebookId: String?
    var facebookToken: String?
    var googleId: String?
    
    override init() {
        //empty constructor
    }
    
    func login(viewController: UIViewController, managerCallBack: @escaping ((_ data: SocialUser?, _ error: Responses?) -> ())) {
        fatalError("must be implemented")
    }
    
    func logout() {
        fatalError("must be implemented")
    }
    
    func createSocialUser() -> SocialUser {
        return SocialUser(
            socialFirstName: socialFirstName,
            socialLastName: socialLastName,
            socialEmail: socialEmail!,
            facebookId: facebookId,
            facebookToken: facebookToken,
            googleId: googleId)
    }
    
}
