//
//  LogManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 01..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class LogManager: BaseManager {
    
    //MARK: properties
    var messageCallback: ((_ data: String?, _ error: Responses?) -> ())?
    var versionCallback: ((_ data: Int?, _ error: Responses?) -> ())?
    
    //MARK: init
    static let sharedInstance = LogManager()
    private override init() {
        super.init()
        //private constructor
    }
    
    //MARK: functions
    func checkSystemInfo() {
        SystemInfoHelper.addSystemInfoToDb()
    }
    
    func getSystemInfo() -> SystemInfo? {
        return SystemInfoHelper.getActualSystemInfo()
    }
    
    func logEvent(event: String) {
        let logObject = LogObject.createLogObject(log: event)
        LogObjectDbLoader.sharedInstance.addData(data: logObject)
    }
    
    //TODO: change it to the real implementation
    func sendFeedback(managerCallback: @escaping (_ data: Bool?, _ error: Responses?) -> ()) -> BaseManagerType {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            managerCallback(true, nil)
        })
        return UserManagerType.send_feedback
    }
    
    func getMessage() {
        let downloadMessage = DownloadMessage()
        runUser(serverService: downloadMessage, managerCallBack: { (data, error) in
            if let callback = self.messageCallback {
                callback(data, error)
            }
            
            self.getActualVersionCode()
        })
    }
    
    private func getActualVersionCode() {
        let downloadVersionCode = DownloadVersionCode()
        runUser(serverService: downloadVersionCode, managerCallBack: versionCallback)
    }
    
}
