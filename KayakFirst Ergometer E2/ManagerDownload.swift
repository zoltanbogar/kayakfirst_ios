//
//  ManagerDownload.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownload<E> {
    
    //MARK: constants
    private let timeCacheMillis: Double = 2 * 60 * 1000 //2 mins
    
    //MARK: properties
    private let preferences = UserDefaults.standard
    
    internal var serverError: String?
    
    //MARK: functions
    func callServer() -> String? {
        let data: E? = runServer()
        
        if serverError == nil {
            setCacheInvalid()
            
            deleteDataFromLocale()
            
            if let dataValue = data {
                addDataToLocale(data: dataValue)
            }
        }
        
        return serverError
    }
    
    func getDataFromServer() -> E? {
        return getDataFromLocale()
    }
    
    func isCacheInvalid() -> Bool {
        let cacheTimestamp = preferences.double(forKey: getKeyCache())
        let timeDiff = currentTimeMillis() - cacheTimestamp
        
        return timeDiff >= getCacheTime()
    }
    
    private func setCacheInvalid() {
        preferences.set(currentTimeMillis(), forKey: getKeyCache())
        preferences.synchronize()
    }
    
    internal func getCacheTime() -> Double {
        return timeCacheMillis
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
    
    internal func addDataToLocale(data: E) {
        fatalError("must be implemented")
    }
    
    internal func isEqual(anotherManagerDownload: ManagerDownload<E>) {
        fatalError("must be implemented")
    }
    
    internal func getKeyCache() -> String {
        fatalError("must be implemented")
    }
    
}
