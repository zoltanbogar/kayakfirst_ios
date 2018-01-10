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
    private static let keySame = "key_push_token_same"
    
    //MARK: properties
    private static let preferences = UserDefaults.standard
    
    class func setToken(pushToken: String) {
        let previousToken = getToken()
        
        var isSame = false
        
        if let previousToken = previousToken {
            isSame = previousToken == pushToken
        }
        
        preferences.set(isSame, forKey: keySame)
        preferences.set(pushToken, forKey: keyPush)
        preferences.synchronize()
        
        uploadPushId()
    }
    
    class func uploadPushId() {
        let isChanged = !isSame()
        
        if isChanged {
            let pushId = getToken()
            
            if let pushIdValue = pushId {
                UserManager.sharedInstance.uploadPushId(pushId: pushIdValue)
            }
        }
    }
    
    private class func getToken() -> String? {
        let pushId = preferences.string(forKey: keyPush)
        
        return pushId
    }
    
    private class func isSame() -> Bool {
        let isSame = preferences.bool(forKey: keySame)
        
        return isSame
    }
}
