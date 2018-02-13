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
        SystemInfoDbLoader.sharedInstance.addSystemInfo(systemInfo: createSystemInfo())
    }
    
    class func getActualSystemInfo() -> SystemInfo? {
        let list = getSystemInfos()
        
        if list != nil && list!.count > 0 {
            return list![list!.count - 1]
        }
        return nil
    }
    
    class func getSystemInfos() -> [SystemInfo]? {
        return SystemInfoDbLoader.sharedInstance.loadData(predicate: nil)
    }
    
    private class func createSystemInfo() -> SystemInfo {
        let userName = UserManager.sharedInstance.getUserName()
        let userId = UserManager.sharedInstance.getUserId()
        
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
