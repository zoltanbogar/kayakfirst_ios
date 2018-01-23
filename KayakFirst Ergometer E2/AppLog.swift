//
//  KayakLog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

//TODO
let logNeeded = false

private let logDateFormat = "HH.mm.ss.SSS"

func log (_ key: String, _ message: Any) {
    if logNeeded {
        let date = DateFormatHelper.getDate(dateFormat: logDateFormat, timeIntervallSince1970: currentTimeMillis())
        print("\(date) - \(key): \(message)")
    }
}

func initCrashlytics(appdelegate: AppDelegate) {
    if (!logNeeded) {
        Fabric.with([Crashlytics.self])
    }
}

func checkSystemInfo() {
    SystemInfoHelper.addSystemInfoToDb()
}

class AppLog {
    
    private static var sessionId: Double = 0
    private static var file: URL?
    
    class func getSystemInfo() -> SystemInfo? {
        return SystemInfoHelper.getActualSystemInfo()
    }
    
    class func logUserData(_ logLine: String) {
        if logNeeded {
            log("LOG", logLine)
            
            createLogFile()
            
            do {
                try logLine.appendLineToURL(fileURL: file!)
                _ = try String(contentsOf: file!, encoding: String.Encoding.utf8)
            }
            catch {
                log("EXCEPTION", error)
            }
        }
    }
    
    private class func createLogFile() {
        if sessionId != Telemetry.sharedInstance.sessionId {
            file = getDocumentsDirectory().appendingPathComponent("M_\(DateFormatHelper.getDate(dateFormat: "yyyyMMddkkmmss", timeIntervallSince1970: currentTimeMillis())).txt")
            
            sessionId = Telemetry.sharedInstance.sessionId
        }
    }
    
    private class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
