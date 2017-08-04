//
//  PushNotificationHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PushNotificationHelper {
    
    //MARK: constants
    private static let keyPush = "key_push_token"
    
    //MARK: properties
    private static let preferences = UserDefaults.standard
    
    class func setToken(pushToken: String) {
        preferences.set(pushToken, forKey: keyPush)
        preferences.synchronize()
        
        uploadPushId()
    }
    
    class func uploadPushId() {
        let pushId = getToken()
        
        if let pushIdValue = pushId {
            UserManager.sharedInstance.uploadPushId(pushId: pushIdValue)
        }
    }
    
    private class func getToken() -> String? {
        let pushId = preferences.string(forKey: keyPush)
        
        return pushId
    }
}
