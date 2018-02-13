//
//  SystemInfoDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 23..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class SystemInfoDbLoader: BaseDbLoader<SystemInfo> {
    
    //MARK: constants
    static let tableName = "system_info_table"
    
    //MARK: init
    static let sharedInstance = SystemInfoDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let versionCodeKey = "versionCode"
        static let versionNameKey = "versionName"
        static let localeKey = "locale"
        static let brandKey = "brand"
        static let modelKey = "model"
        static let osVersionKey = "osVersion"
        static let userNameKey = "userName"
    }
    
    //MARK: columns
    private let versionCode = Expression<Int>(PropertyKey.versionCodeKey)
    private let versionName = Expression<String>(PropertyKey.versionNameKey)
    private let locale = Expression<String>(PropertyKey.localeKey)
    private let brand = Expression<String>(PropertyKey.brandKey)
    private let model = Expression<String>(PropertyKey.modelKey)
    private let osVersion = Expression<String>(PropertyKey.osVersionKey)
    private let userName = Expression<String>(PropertyKey.userNameKey)
    
    override func getTableName() -> String {
        return SystemInfoDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(baseId, primaryKey: .autoincrement)
            t.column(versionCode)
            t.column(versionName)
            t.column(timestamp)
            t.column(locale)
            t.column(brand)
            t.column(model)
            t.column(osVersion)
            t.column(userName)
            t.column(userId)
        })
    }
    
    //MARK: insert
    func addSystemInfo(systemInfo: SystemInfo) {
        let systemInfoList = loadData(predicate: nil)
        var shouldInsert = true
        
        if let systemInfoList = systemInfoList {
            for i in systemInfoList {
                if i == systemInfo {
                    shouldInsert = false
                    break
                }
            }
        }
        
        if shouldInsert {
            addData(data: systemInfo)
        }
    }
    
    override func addData(data: SystemInfo?) {
        if let systemInfo = data {
            let insert = table!.insert(self.versionCode <- systemInfo.versionCode, self.versionName <- systemInfo.versionName, self.timestamp <- Double(Int64(systemInfo.timestamp)), self.locale <- systemInfo.locale, self.brand <- systemInfo.brand, self.model <- systemInfo.model, self.osVersion <- systemInfo.osVersion, self.userName <- systemInfo.userName, self.userId <- systemInfo.userId)
            
            let rowId = try? db?.run(insert)
        }
    }
    
    //MARK: query
    override func loadData(predicate: Expression<Bool>?) -> [SystemInfo]? {
        var systemInfoList: [SystemInfo]?
        
        let userId = UserManager.sharedInstance.getUserId()
        
        do {
            var queryPredicate = self.userId == userId
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            log("DB_TEST", "\(queryPredicate)")
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            systemInfoList = [SystemInfo]()
            
            for systemInfoDb in dbList {
                let versionCode = systemInfoDb[self.versionCode]
                let versionName = systemInfoDb[self.versionName]
                let timestamp = systemInfoDb[self.timestamp]
                let locale = systemInfoDb[self.locale]
                let brand = systemInfoDb[self.brand]
                let model = systemInfoDb[self.model]
                let osVersion = systemInfoDb[self.osVersion]
                let userName = systemInfoDb[self.userName]
                let userId = systemInfoDb[self.userId]
                
                let systemInfo = SystemInfo(
                    versionCode: versionCode,
                    versionName: versionName,
                    timestamp: timestamp,
                    locale: locale,
                    brand: brand,
                    model: model,
                    osVersion: osVersion,
                    userName: userName,
                    userId: userId)
                
                systemInfoList?.append(systemInfo)
                
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return systemInfoList
    }
    
    //MARK: update
    override func updateData(data: SystemInfo) {
        //nothing here
    }
    
    //MARK: delete
    func deleteOldData() {
        let predicate = self.timestamp < getOldDataTimestamp(oldDataDays: oldDataDays)
        deleteData(predicate: predicate)
    }
    
    override func deleteData(predicate: Expression<Bool>?) -> Int {
        var deletedRows = 0
        
        let deleteData = table!.filter(predicate!)
        
        do {
            deletedRows = try db!.run(deleteData.delete())
        } catch {
            log(databaseLogTag, error)
        }
        return deletedRows
    }
    
}
