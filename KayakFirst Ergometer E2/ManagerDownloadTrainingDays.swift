//
//  ManagerDownloadTrainingDaysNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 25..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadTrainingDays: ManagerDownload<DaysObject> {
    
    private let sumTrainingDbLoader: SumTrainingDbLoader
    private let downloadTrainingDays: DownloadTrainingDays
    private let managerModifyTrainingDelete: ManagerModifyTrainingDelete
    private let managerUploadTrainings: ManagerUploadTrainings
    
    init(sumTrainingDbLoader: SumTrainingDbLoader, downloadTrainingDays: DownloadTrainingDays, managerModifyTrainingDelete: ManagerModifyTrainingDelete, managerUploadTrainings: ManagerUploadTrainings) {
        self.sumTrainingDbLoader = sumTrainingDbLoader
        self.downloadTrainingDays = downloadTrainingDays
        self.managerModifyTrainingDelete = managerModifyTrainingDelete
        self.managerUploadTrainings = managerUploadTrainings
    }
    
    override func getData() -> DaysObject {
        var localeSessionIds = getLocaleSessionIds()
        var serverSessionIds = getServerSessionIds()
        let deletedSessionIds = getDeletedSessionIds()
        let notUploadedSessionIds = getNotUploadedSessionIds()
        
        serverSessionIds = removeDeletedIdsFromServerIds(deletedSessionIds: deletedSessionIds, serverIds: serverSessionIds)
        
        if serverError == nil {
            var sessionIdsToDelete = getSessionIdsToDelete(serverIds: serverSessionIds, localeIds: localeSessionIds, notUploadedIds: notUploadedSessionIds)
            
            deleteTrainingsDataBySessionIds(sessionIds: sessionIdsToDelete)
            
            localeSessionIds = removeDeletedIdsFromLocale(deletedSessionIds: sessionIdsToDelete, localeIds: localeSessionIds)
        }
        
        return createDaysObject(serverSessionIds: serverSessionIds, localeIds: localeSessionIds)
    }
    
    private func getLocaleSessionIds() -> [Double]? {
        return sumTrainingDbLoader.getSessionIds()
    }
    
    private func getServerSessionIds() -> [Double]? {
        let serverIds = downloadTrainingDays.run()
        serverError = downloadTrainingDays.error
        return serverIds
    }
    
    private func getDeletedSessionIds() -> [Double]? {
        return managerModifyTrainingDelete.getDeletedSessionIds()
    }
    
    private func getNotUploadedSessionIds() -> [Double]? {
        return managerUploadTrainings.getNotUploadedSessionIds()
    }
    
    private func removeDeletedIdsFromServerIds(deletedSessionIds: [Double]?, serverIds: [Double]?) -> [Double]? {
        if deletedSessionIds != nil && serverIds != nil {
            return Array(Set(serverIds!).subtracting(deletedSessionIds!))
        }
        return serverIds
    }
    
    private func removeDeletedIdsFromLocale(deletedSessionIds: [Double]?, localeIds: [Double]?) -> [Double]? {
        if deletedSessionIds != nil && localeIds != nil {
            return Array(Set(localeIds!).subtracting(deletedSessionIds!))
        }
        return localeIds
    }
    
    private func getSessionIdsToDelete(serverIds: [Double]?, localeIds: [Double]?, notUploadedIds: [Double]?) -> [Double] {
        var serverSessions = [Double]()
        if let serverIds = serverIds {
            serverSessions.append(contentsOf: serverIds)
        }
        var localeSessions = [Double]()
        if let localeIds = localeIds {
            localeSessions.append(contentsOf: localeIds)
        }
        var notUploadedSessions = [Double]()
        if let notUploadedIds = notUploadedIds {
            notUploadedSessions.append(contentsOf: notUploadedIds)
        }
        
        localeSessions = Array(Set(localeSessions).subtracting(serverSessions))
        localeSessions = Array(Set(localeSessions).subtracting(notUploadedSessions))
        
        return localeSessions
    }
    
    private func deleteTrainingsDataBySessionIds(sessionIds: [Double]?) {
        //TODO: delete Training, TrainingAvg, SumTraining, PlanTraining
    }
    
    private func createDaysObject(serverSessionIds: [Double]?, localeIds: [Double]?) -> DaysObject {
        var serverIds = serverSessionIds
        
        if serverSessionIds != nil && localeIds != nil {
            serverIds = Array(Set(serverIds!).subtracting(localeIds!))
        }
        
        var daysObject = DaysObject()
        
        if let serverIds = serverIds {
            for serverId in serverIds {
                let midnightTime = DateFormatHelper.getZeroHour(timeStamp: serverId)
                
                var timestampObject = daysObject[midnightTime]
                
                if timestampObject == nil {
                    timestampObject = TimestampObject()
                }
                
                timestampObject?.addServerId(timestampServer: serverId)
                
                daysObject[midnightTime] = timestampObject
            }
        }
        
        if let localeIds = localeIds {
            for localeId in localeIds {
                let midnightTime = DateFormatHelper.getZeroHour(timeStamp: localeId)
                
                var timestampObject = daysObject[midnightTime]
                
                if timestampObject == nil {
                    timestampObject = TimestampObject()
                }
                
                timestampObject?.addLocaleId(timestampLocale: localeId)
                
                daysObject[midnightTime] = timestampObject
            }
        }
        
        return daysObject
    }
    
    override func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadTrainingDays
    }
    
}
