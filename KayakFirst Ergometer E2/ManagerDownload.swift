//
//  ManagerDownload.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol ManagerDownloadProtocol {
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool
}

class ManagerDownload<E> {
    
    //MARK: constants
    private let timeCacheMillis: Double = 2 * 60 * 1000 //2 mins
    
    //MARK: properties
    private let preferences = UserDefaults.standard
    
    internal var serverError: Responses?
    
    //MARK: functions
    func shouldWaitForStack() -> Bool {
        return true
    }
    
    func callServer() -> String? {
        let data: E? = runServer()
        
        if serverError == nil {
            setCacheInvalid()
            
            deleteDataFromLocale()
            
            if let dataValue = data {
                addDataToLocale(data: dataValue)
            }
        }
        
        return serverError?.rawValue
    }
    
    func getDataFromServer() -> E? {
        return getDataFromLocale()
    }
    
    func isCacheInvalid() -> Bool {
        let cacheTimestamp = preferences.double(forKey: getKeyCacheWithUserId())
        let timeDiff = currentTimeMillis() - cacheTimestamp
        
        return timeDiff >= getCacheTime()
    }
    
    private func setCacheInvalid() {
        preferences.set(currentTimeMillis(), forKey: getKeyCacheWithUserId())
        preferences.synchronize()
    }
    
    internal func getCacheTime() -> Double {
        return timeCacheMillis
    }
    
    private func getKeyCacheWithUserId() -> String {
        return ManagerUpload.getStaticDbUpload(db: getKeyCache())
    }
    
    //MARK: abstract functions
    func getDataFromLocale() -> E? {
        fatalError("must be implemented")
    }
    
    internal func runServer() -> E? {
        fatalError("must be implemented")
    }
    
    internal func deleteDataFromLocale() {
        fatalError("must be implemented")
    }
    
    internal func addDataToLocale(data: E?) {
        fatalError("must be implemented")
    }
    
    internal func getKeyCache() -> String {
        fatalError("must be implemented")
    }
    
}
