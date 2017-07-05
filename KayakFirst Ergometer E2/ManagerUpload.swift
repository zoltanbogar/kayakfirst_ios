//
//  ManagerUpload.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUpload {
    
    //MARK: constants
    private static let dbUpload = "manager_upload_db"
    
    //MARK: properties
    private static let preferences = UserDefaults.standard
    
    //MARK: functions
    func callServer() -> String? {
        let error = runServer(pointers: getPointers())
        
        if error == nil {
            removeFromStack(uploadType: getUploadType())
        }
        
        return error
    }
    
    class func getStack() -> [String]? {
        let dictionary = preferences.persistentDomain(forName: dbUpload)
        
        return [String]()
        //TODO
        //return dictionary?.keys
    }
    
    class func addToStack(uploadType: UploadType, pointer: String?) {
        /*UploadTimer.startTimer()
        
        var values = preferences.persistentDomain(forName: dbUpload)?.values[uploadType.rawValue]
        
        */
    }
    
    //TODO
    class func getManagerUploadByType(uploadType: String) -> [ManagerUpload] {
        var managerUploads = [ManagerUpload]()
        
        return managerUploads
    }
    
    internal func removeFromStack(uploadType: UploadType) {
        //TODO
    }
    
    //TODO
    internal func getPointers() -> [String]? {
        return [String]()
    }
    
    //MARK: abstract functions
    internal func runServer(pointers: [String]?) -> String? {
        fatalError("must be implemented")
    }
    
    internal func getUploadType() -> UploadType {
        fatalError("must be implemented")
    }
    
}
