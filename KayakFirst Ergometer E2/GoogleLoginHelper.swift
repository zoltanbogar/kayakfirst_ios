//
//  GoogleLoginHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class GoogleLoginHelper: SocialLoginHelper, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private var viewController: UIViewController?
    private var managerCallback: ((_ data: SocialUser?, _ error: Responses?) -> ())?
    
    static let sharedInstance = GoogleLoginHelper()
    
    private override init() {
        //private empty contsructor
    }
    
    override func login(viewController: UIViewController, managerCallBack: (((_ data: SocialUser?, _ error: Responses?) -> ()))?) {
        self.viewController = viewController
        self.managerCallback = managerCallBack
        
        initGoogleSignIn()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    private func initGoogleSignIn() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let email = user.profile.email
            let googleId = user.authentication.idToken
            
            self.socialEmail = email!
            self.googleId = googleId
            self.socialFirstName = user.profile.givenName
            self.socialLastName = user.profile.familyName
            
            managerCallback?(createSocialUser(), nil)
        } else {
            managerCallback?(nil, Responses.error_social)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //nothing here
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //nothing here
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
}
