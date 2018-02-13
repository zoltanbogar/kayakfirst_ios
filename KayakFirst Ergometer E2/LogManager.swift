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
        DispatchQueue.global().async {
            SystemInfoDbLoader.sharedInstance.deleteOldData()
            LogObjectDbLoader.sharedInstance.deleteOldData()
            
            SystemInfoHelper.addSystemInfoToDb()
        }
    }
    
    func getSystemInfo() -> SystemInfo? {
        return SystemInfoHelper.getActualSystemInfo()
    }
    
    func logEvent(event: String) {
        let logObject = LogObject.createLogObject(log: event)
        LogObjectDbLoader.sharedInstance.addData(data: logObject)
    }
    
    //MARK: ergo
    func logErgoCommandList(commandList: [MeasureCommandErgometer]) {
        var message = ""
        for command in commandList {
            let commandName = command.getCommand().rawValue
            let cycleIndex = command.getCycleIndex()
            let value = command.getValue()
            
            let commandMessage = commandName + " - " + "\(cycleIndex)" + " - " + "\(value)" + " ; "
            
            message += commandMessage
        }
        logEvent(event: "bt command: \(message)")
    }
    
    func logBtDisconnect(disconnectByWho: String) {
        logEvent(event: "bt disconnect by \(disconnectByWho)")
    }
    
    //MARK: training
    func logPlanEvent(plan: Plan?, event: Event?) {
        let planId: String? = plan != nil ? plan!.planId : nil
        let eventId: String? = event != nil ? event!.eventId : nil
        
        var message: String? = nil
        
        if let planId = planId {
            message = "StartTrainingActivity: Plan - \(planId)"
            if let eventId = eventId {
                let eventMessage = "Event - \(eventId)"
                message = message! + " ; " + eventMessage
            }
        }
        
        if let message = message {
            logEvent(event: message)
        }
    }
    
    func logStopCycle(stopByWho: String) {
        logEvent(event: "cycle stop by \(stopByWho)")
    }
    
    func logTelemetryObject(training: TrainingNew) {
        let f = "f: \(training.force)"
        let v = "v: \(training.speed)"
        let s = "s: \(training.distance)"
        let spm = "spm: \(training.strokes)"
        let t200 = "t200: \(training.t200)"
        
        let message = f + " ; " + v + " ; " + s + " ; " + spm + " ; " + t200
        logEvent(event: message)
    }
    
    func logDashboardRefresh(isRefresh: Bool) {
        logEvent(event: "dashboardRefresh: \(isRefresh)")
    }
    
    //MARK: sync
    func logServer(message: Any) {
        log(alamofireLogTag, message)
        
        logEvent(event: "\(message)")
    }
    
    func sendFeedback(managerCallback: @escaping (_ data: Bool?, _ error: Responses?) -> (), message: String) -> BaseManagerType {
        let uploadLogs = UploadLogs(message: message)
        runUser(serverService: uploadLogs, managerCallBack: managerCallback)
        return LogManagerType.send_feedback
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
