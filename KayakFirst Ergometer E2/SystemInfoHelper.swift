//
//  SystemInfoHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 23..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class SystemInfoHelper {
    
    //MARK: functions
    class func addSystemInfoToDb() {
        SystemInfoDbLoader.sharedInstance.addData(data: createSystemInfo())
    }
    
    class func getActualSystemInfo() -> SystemInfo? {
        let list = SystemInfoDbLoader.sharedInstance.loadData(predicate: nil)
        
        if let list = list {
            return list[0]
        }
        return nil
    }
    
    private class func createSystemInfo() -> SystemInfo {
        let user = UserManager.sharedInstance.getUser()
        let userName = user != nil ? user?.userName : nil
        let userId: Int64 = user != nil ? user!.id : 0
        
        return SystemInfo(
            versionCode: Int(AppDelegate.buildString)!,
            versionName: AppDelegate.versionString,
            timestamp: currentTimeMillis(),
            locale: Locale.preferredLanguages[0],
            brand: "Apple",
            model: UIDevice.current.modelName,
            osVersion: UIDevice.current.systemVersion,
            userName: userName,
            userId: userId)
    }
    
}
