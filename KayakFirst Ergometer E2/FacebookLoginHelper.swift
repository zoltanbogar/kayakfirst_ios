//
//  FacebookLoginHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookLoginHelper: SocialLoginHelper {
    
    static let sharedInstance = FacebookLoginHelper()
    
    private override init() {
        //private empty constructor
    }
    
    override func login(viewController: UIViewController, managerCallBack: @escaping ((_ data: SocialUser?, _ error: Responses?) -> ())) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = .web
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController, handler: { (result, error) -> Void in
            if error == nil {
                if let resultValue = result {
                    if !resultValue.isCancelled {
                        
                        self.facebookToken = resultValue.token.tokenString
                        
                        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: self.facebookToken, version: nil, httpMethod: "GET")
                        
                        if let reqValue = req {
                            reqValue.start(completionHandler: { (connection, result, error) -> Void in
                                
                                if ((error) != nil) {
                                    managerCallBack(nil, Responses.error_social)
                                } else {
                                    let data:[String:AnyObject] = result as! [String : AnyObject]
                                    
                                    self.socialEmail = data["email"] as! String!
                                    
                                    let name = data["name"] as! String
                                    let fullNameArr = name.characters.split{$0 == " "}.map(String.init)
                                    self.socialFirstName = fullNameArr[0]
                                    self.socialLastName = fullNameArr.count > 1 ? fullNameArr[1] : nil
                                    self.facebookId = data["id"] as! String
                                    
                                    managerCallBack(self.createSocialUser(), nil)
                                }
                            })
                        }
                    } else {
                        managerCallBack(nil, Responses.error_social)
                    }
                }
            }
        })
    }
    
    override func logout() {
        FBSDKLoginManager().logOut()
    }
    
}
